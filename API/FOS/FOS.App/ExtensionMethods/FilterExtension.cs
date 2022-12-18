using FOS.App.Configs;
using FOS.Core.SearchModels;
using System.Linq.Expressions;
using System.Reflection;

namespace FOS.App.ExtensionMethods
{
    /// <summary>
    /// This class is used to build lambda expression i.e (x=>x.fname = "some value")
    /// which will be passed to .Where extension function which will return records that meets search values
    /// </summary>
    internal static class FilterExtension
    {
        public static IQueryable<T> Search<T>(this IQueryable<T> source,
                                            IList<SearchBaseModel> filters)
        {
            //Select filters which have values in Key, Operator and value
            filters = filters?.Where(f => f != null &&
           !string.IsNullOrWhiteSpace(f.Key) &&
           !string.IsNullOrWhiteSpace(f.Operator) &&
           !string.IsNullOrWhiteSpace(f.Value?.ToString())
           )?.ToList();
            //If there's no filters, return original list
            if (filters == null || filters.Count < 1)
                return source;
            //Here select filters which has Key that mathes column name in database
            var intersectedProps = filters.Select(f => f.Key)
                .Intersect(
                typeof(T)
                .GetProperties(BindingFlags.Instance | BindingFlags.Public)
                .Select(p => p.Name)
                );
            //If non matched, return original list
            if (intersectedProps == null || intersectedProps.Count() < 1)
                return source;
            //Create expression parameter with type as recieved class type
            ParameterExpression param = Expression.Parameter(typeof(T), "t");

            //build the expression
            var expression = (Expression)null;
            //loop through intersected props
            foreach (var propertyName in intersectedProps)
            {
                //Get filter by property name
                var selectedFilter = filters.FirstOrDefault(f => f.Key == propertyName);
                if (selectedFilter == null)
                    continue;
                //build expression
                var currentExpression = GetExpression<T>(param, selectedFilter);

                if (expression == null)
                    expression = currentExpression;
                else
                    expression = Expression.AndAlso(expression, currentExpression);
            }
            //convert expression to lambda i.e(x=>x.Fname == "Test")
            var lambda = Expression.Lambda<Func<T, bool>>(expression, param);
            //Apply lambda expression on the list
            return source.Where(lambda);
        }

        private static Expression GetExpression<T>(ParameterExpression param, SearchBaseModel filter)
        {
            //Get type of class
            var type = typeof(T);
            //Get property of that class by filter.key
            var prop = type.GetProperty(filter.Key);
            //Get type of that property
            Type propType = prop.PropertyType;
            //if it's nullable property, we get actual datatype i.e(int? p will return int)
            if (propType.IsGenericType && propType.GetGenericTypeDefinition() == typeof(Nullable<>))
                propType = propType.GetGenericArguments()[0];
            //convert received search value to it's actual type
            var changedValue = Convert.ChangeType(filter.Value?.ToString(), propType);
            //create expression i.e.(x=>x.Fname)
            MemberExpression member = Expression.Property(param, filter.Key);
            ConstantExpression constant = Expression.Constant(changedValue);
            //create constant expression i.e.(convert( value,datatype) )
            var convertedExpression = Expression.Convert(constant, prop.PropertyType);

            //get method name by operator through Filter Configuration Reader
            var methodName = FilterConfigurationReader.Get(filter.Operator)?.Method;
            //check if property type is an object or string, then call expression method
            if (propType == typeof(string) || propType == typeof(object))
            {
                MethodInfo method = propType.GetMethod(methodName, new[] { propType });
                var containsMethodExp = Expression.Call(member, method, convertedExpression);
                return containsMethodExp;
            }
            else
            {
                //get method by Reflection
                var expType = typeof(Expression);
                MethodInfo method = expType.GetMethods().Where(m => m.Name == methodName).First(mi => mi.GetParameters().Count() == 2);
                var expResult = method.Invoke(null, new Expression[] { member, convertedExpression });
                return expResult == null ? null : (Expression)expResult;
            }
        }
    }
}

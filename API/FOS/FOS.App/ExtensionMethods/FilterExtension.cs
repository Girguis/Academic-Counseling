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
            filters = filters?.Where(f => f != null &&
           !string.IsNullOrWhiteSpace(f.Key) &&
           !string.IsNullOrWhiteSpace(f.Operator) &&
           !string.IsNullOrWhiteSpace(f.Value?.ToString())
           )?.ToList();

            if (filters == null || filters.Count < 1)
                return source;

            var intersectedProps = filters.Select(f => f.Key)
                .Intersect(
                typeof(T)
                .GetProperties(BindingFlags.Instance | BindingFlags.Public)
                .Select(p => p.Name)
                );

            if (intersectedProps == null || intersectedProps.Count() < 1)
                return source;

            ParameterExpression param = Expression.Parameter(typeof(T), "t");

            // build the expression
            var expression = (Expression)null;
            foreach (var propertyName in intersectedProps)
            {
                var selectedFilter = filters.FirstOrDefault(f => f.Key == propertyName);
                if (selectedFilter == null)
                    continue;

                var currentExpression = GetExpression<T>(param, selectedFilter);

                if (expression == null)
                    expression = currentExpression;
                else
                    expression = Expression.AndAlso(expression, currentExpression);
            }

            var lambda = Expression.Lambda<Func<T, bool>>(expression, param);
            return source.Where(lambda);
        }

        private static Expression GetExpression<T>(ParameterExpression param, SearchBaseModel filter)
        {
            var type = typeof(T);
            var prop = type.GetProperty(filter.Key);
            Type propType = prop.PropertyType;
            if (propType.IsGenericType && propType.GetGenericTypeDefinition() == typeof(Nullable<>))
                propType = propType.GetGenericArguments()[0];

            var changedValue = Convert.ChangeType(filter.Value?.ToString(), propType);
            MemberExpression member = Expression.Property(param, filter.Key);
            ConstantExpression constant = Expression.Constant(changedValue);
            var convertedExpression = Expression.Convert(constant, prop.PropertyType);

            var methodName = FilterConfiguratioReader.Get(filter.Operator)?.Method;

            if (propType == typeof(string) || propType == typeof(object))
            {
                MethodInfo method = propType.GetMethod(methodName, new[] { propType });
                var containsMethodExp = Expression.Call(member, method, convertedExpression);
                return containsMethodExp;
            }
            else
            {
                var expType = typeof(Expression);
                MethodInfo method = expType.GetMethods().Where(m => m.Name == methodName).First(mi => mi.GetParameters().Count() == 2);
                var expResult = method.Invoke(null, new Expression[] { member, convertedExpression });
                return expResult == null ? null : (Expression)expResult;
            }
        }
    }
}

using FOS.Core.SearchModels;
using System.Linq.Expressions;
using System.Reflection;

namespace FOS.App.ExtensionMethods
{
    internal static class FilterExtension
    {
        public static IEnumerable<T> Search<T>(this IQueryable<T> source,
            List<SearchBaseModel> filters)
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

            var argumentExpression = Expression.Parameter(typeof(T), "x");
            // build the expression
            var expression = (Expression)null;
            foreach (var propertyName in intersectedProps)
            {
                var selectedFilter = filters.FirstOrDefault(f => f.Key == propertyName);
                if (selectedFilter == null)
                    continue;

                var currentExpression = GetExpression(argumentExpression, selectedFilter);

                if (expression == null)
                    expression = currentExpression;
                else
                    expression = Expression.AndAlso(expression, currentExpression);
            }

            var lambda = Expression.Lambda<Func<T, bool>>(expression, argumentExpression);

            return source.Where(lambda).ToList();
        }

        private static readonly Dictionary<string, string> dict = new Dictionary<string, string>()
        {
            { ">", "GreaterThan" },
            { "<", "LessThan" },
            { "contains", "Contains" },
            { "=", "Equals" }
        };

        private static Expression GetExpression(ParameterExpression parameterExp, SearchBaseModel model)
        {
            var propType = model.Value.GetType();
            Expression propertyExp = Expression.Property(parameterExp, model.Key);
            Expression someValue = Expression.Constant(model.Value, propType);

            dict.TryGetValue(model.Operator, out string methodName);

            if (propType == typeof(string) || propType == typeof(object))
            {
                MethodInfo method = propType.GetMethod(methodName, new[] { propType });
                var containsMethodExp = Expression.Call(propertyExp, method, someValue);
                return containsMethodExp;
            }

            if (model.Operator == ">")
            {
                return Expression.GreaterThan(
                Expression.Property(parameterExp, model.Key),
                Expression.Constant(model.Value)
                );
            }
           
            return Expression.NotEqual(propertyExp, someValue);
            //else
            //{
            //    var expType = typeof(Expression);
            //    var method = expType.GetMethods().Single(method =>
            //method.Name == methodName && method.GetParameters().Length == 2);

            //    object magicClassObject = method.Invoke(null, new object[] { propertyExp.ReduceExtensions(), someValue.ReduceExtensions()});
            //    return (MethodCallExpression)magicClassObject;
            //}
        }
    }
}

using System.Linq.Expressions;
using System.Reflection;

namespace FOS.App.ExtensionMethods
{
    internal static class QueryHelper
    {
        private static readonly MethodInfo OrderByMethod =
            typeof(Queryable).GetMethods().Single(method =>
            method.Name == "OrderBy" && method.GetParameters().Length == 2);

        private static readonly MethodInfo OrderByDescendingMethod =
            typeof(Queryable).GetMethods().Single(method =>
            method.Name == "OrderByDescending" && method.GetParameters().Length == 2);

        public static bool Exists<T>(this IQueryable<T> source, string propertyName)
        {
            return typeof(T).GetProperty(propertyName, BindingFlags.IgnoreCase |
                BindingFlags.Public | BindingFlags.Instance) != null;
        }

        public static IQueryable<T> OrderByProperty<T>(
           this IQueryable<T> source, string propertyName, bool ascending = false)
        {
            if (typeof(T).GetProperty(propertyName, BindingFlags.IgnoreCase |
                BindingFlags.Public | BindingFlags.Instance) == null)
            {
                return null;
            }
            ParameterExpression paramterExpression = Expression.Parameter(typeof(T));
            Expression orderByProperty = Expression.Property(paramterExpression, propertyName);
            LambdaExpression lambda = Expression.Lambda(orderByProperty, paramterExpression);

            MethodInfo method = ascending ? OrderByMethod : OrderByDescendingMethod;

            MethodInfo genericMethod =
              method.MakeGenericMethod(typeof(T), orderByProperty.Type);
            object ret = genericMethod.Invoke(null, new object[] { source, lambda });
            return (IQueryable<T>)ret;
        }
    }
    internal static class OrderExtension
    {
        public static IQueryable<T> Order<T>(this IQueryable<T> source, string orderBy = null, bool ascending = false)
        {
            if (string.IsNullOrEmpty(orderBy) || !source.Exists(orderBy))
                return source;

            return source.OrderByProperty(orderBy, ascending);
        }
    }
}

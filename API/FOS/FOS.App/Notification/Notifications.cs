using FirebaseAdmin;
using FirebaseAdmin.Messaging;
using Google.Apis.Auth.OAuth2;

namespace FOS.App.Notification
{
    public static class Notifications
    {
        public static async void Notify(string title, string massage)
        {
            if (FirebaseApp.DefaultInstance == null)
            {
                FirebaseApp.Create(new AppOptions()
                {
                    Credential = GoogleCredential.FromFile("Firebase_PrivateKey.json")
                });
            }
            //var registrationToken = "";
            var message = new Message()
            {
                //Token = registrationToken,
                Topic = "all",
                Notification = new FirebaseAdmin.Messaging.Notification()
                {
                    Title = title,
                    Body = massage
                }
            };
            var response = await FirebaseMessaging.DefaultInstance.SendAsync(message);
        }
    }
}

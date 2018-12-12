using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Net;
using UnityEngine;
using UnityEditor;


namespace STYLY.Uploader
{
	public class RollbarNotifier
    {
		private string ClientToken = "698dbee03eb544a5bb889e0a8a12e594";

		private string ProductionEnvironment = "production";
//		private string DevelopmentEnvironment = "development";

//        private Queue<string> queue = new Queue<string>();

        public static RollbarNotifier Instance = null;

        private string _userEmail = null;
        private string _versionString;

        public static void Init()
        {
            if (Instance == null)
            {
				Instance = new RollbarNotifier();
            }
        }

		public void HandleException(Exception e)
        {
			string condition = e.ToString();
			string stackTrace = e.StackTrace;
			if (stackTrace == null)
				stackTrace = "";

            string level = "error";

            string[] frames = stackTrace.Split('\n');

            List<string> frameMangled = new List<string>();
            for (int i = 0; i < frames.Length; i++)
            {
                string entry = frames[i].Trim().Replace('\'', ' ').Replace('"', ' ');
                if (entry.Length > 0)
                {
                    frameMangled.Add("{\"filename\":\"" + entry + "\"}");
                }
            }

            condition = condition.Trim().Replace('\'', ' ').Replace('"', ' ');
            string[] title = condition.Split(':');
            string clazz = title.Length == 2 ? title[0].Trim() : "exception";
            string msg = title.Length == 2 ? title[1].Trim() : condition;

            string user = GetUserFragment();

            string payload =
                "{" +
                    "\"access_token\": \"" + Instance.ClientToken + "\"," +
                    "\"data\": {" +
					"\"environment\": \"" + Instance.ProductionEnvironment + "\"," +
                      "\"body\": {" +
                            "\"trace\": {" +
                                "\"frames\": [" +
                                    string.Join(",", frameMangled.ToArray()) +
                                "]," +
                                "\"exception\": {" +
                                    "\"class\":\"" + clazz + "\"," +
                                    "\"message\":\"" + msg + "\"" +
                                "}" +
                            "}" +
                        "}," +
                        "\"platform\": \"browser\"," +
                        "\"level\": \"" + level + "\"," +
                        "\"notifier\": {\"name\":\"unityclient\",\"version\":\"1.0.0\"}," +
                        user +
                        (_versionString == null ?
                            "" :
                            "\"code_version\": \"" + _versionString + "\",") +
                        "\"timestamp\": \"" + (int)(DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1))).TotalSeconds + "\"" +
                    "}" +
                "}";

			SendRequest(payload);

        }

        private string GetUserFragment()
        {

            return "\"person\":{" +
                        (_userEmail == null ?
                            "" :
                            "\"email\": \"" + _userEmail + "\"") +
                   "},";
        }

        private void _SetUserID(string email)
        {
            _userEmail = email == null ? null : email.Trim().Replace('\'', ' ').Replace('"', ' ');
        }

        private void _SetVersion(string v)
        {
            _versionString = v.Trim().Replace('\'', ' ').Replace('"', ' ');
        }

        public static void SetUserID(string email = null)
        {
            if (Instance == null)
            {
                return;
            }
            Instance._SetUserID(email);
        }

        public static void SetVersion(string v)
        {
            if (Instance == null)
            {
                return;
            }
            Instance._SetVersion(v);
        }

        public static void LogException(Exception e)
        {
            Debug.LogException(e);
        }

		public void SendError(Error error) {
			if (error.exception != null) {
				this.HandleException (error.exception);
			} else {
				this.Message (error.message, "error", error.extra);
			}
		}

        public void Message(string msg, string level, Dictionary<string,string> extra)
        {
            string user = GetUserFragment();

            string custom = null;
            bool first = true;
            if (extra != null)
            {
                custom = ", \"custom\":{";

                foreach (string key in extra.Keys)
                {
                    if (!first)
                    {
                        custom += ",";
                    }
                    custom += "\""+
                        key.Trim().Replace('\'', ' ').Replace('"', ' ') +
                        "\":\""+
                        extra[key].Trim().Replace('\'', ' ').Replace('"', ' ') +
                        "\"";
                    first = false;
                }
                custom += "}";
            }

            string payload =
                "{" +
                    "\"access_token\": \"" + Instance.ClientToken + "\"," +
                    "\"data\": {" +
					"\"environment\": \""+ Instance.ProductionEnvironment + "\","+
                        "\"body\": {" +
                            "\"message\": {" +
                                "\"body\": \"" + msg.Trim().Replace('\'', ' ').Replace('"', ' ') + "\"" +
                            "}" +
                        "}," +
                        "\"platform\": \"browser\"," +
                        "\"level\": \"" + level + "\"," +
                        "\"notifier\": {\"name\":\"unityclient\",\"version\":\"1.0.0\"}," +
                        user +
                        (_versionString == null ?
                            string.Empty :
                            "\"code_version\": \"" + _versionString + "\",") +
                        "\"timestamp\": \"" + (int)(DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1))).TotalSeconds + "\"" +
                        (custom == null ?
                            string.Empty :
                            custom) +
                    "}" +
                "}";

			SendRequest(payload);
        }

		private void SendRequest(string payload)
        {
			WebClient webClient = new WebClient();
			webClient.Headers[HttpRequestHeader.ContentType] = "application/json;charset=UTF-8";
			webClient.Headers[HttpRequestHeader.Accept] = "application/json";
			webClient.Encoding = Encoding.UTF8;
			webClient.UploadString(new Uri("https://api.rollbar.com/api/1/item/"), payload);
        }

        /*
         * Example:
         * RollbarNotifier.ErrorMsg("Some error", new Dictionary<string, string>
         * {
         *     { "key1", "value1" },
         *     { "key2", "value2" }
         * });
         *
         */

        public static void CriticalMsg(string msg, Dictionary<string,string> extra = null)
        {
            if (Instance == null)
            {
                return;
            }

            Instance.Message(msg, "critical", extra);
        }

        public static void ErrorMsg(string msg, Dictionary<string,string> extra = null)
        {
            if (Instance == null)
            {
                return;
            }

            Instance.Message(msg, "error", extra);
        }

        public static void WarningMsg(string msg, Dictionary<string, string> extra = null)
        {
            if (Instance == null)
            {
                return;
            }

            Instance.Message(msg, "warning", extra);
        }

        public static void InfoMsg(string msg, Dictionary<string, string> extra = null)
        {
            if (Instance == null)
            {
                return;
            }

            Instance.Message(msg, "info", extra);
        }

        public static void DebugMsg(string msg, Dictionary<string, string> extra = null)
        {
            if (Instance == null)
            {
                return;
            }

            Instance.Message(msg, "debug", extra);
        }
    }
}

using System;
using System.Collections.Generic;

namespace STYLY.Uploader
{
	public class Error
	{
		public string message;
		public Dictionary<string,string> extra;
		public Exception exception;

		public Error (string message, Dictionary<string,string> extra = null)
		{
			this.message = message;
			this.extra = extra;
		}

		public Error (Exception exception, Dictionary<string,string> extra = null)
		{
			this.exception = exception;
			this.message = exception.Message;
			this.extra = extra;
		}

		public void ShowDialog () {
			Editor.ShowErrorDialog (this.message);
		}
	}
}


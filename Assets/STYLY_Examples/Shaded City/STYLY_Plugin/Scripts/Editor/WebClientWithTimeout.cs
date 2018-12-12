using System;
using System.Net;

namespace STYLY.Uploader
{
	/// <summary>
	/// System.Net.WebClient with Timeout
	/// https://www.arclab.com/en/kb/csharp/download-file-from-internet-to-string-or-file.html
	/// </summary>
	public class WebClientWithTimeout : WebClient
	{
		protected override WebRequest GetWebRequest (Uri address)
		{
			WebRequest wr = base.GetWebRequest (address);
			wr.Timeout = 5 * 1000; // timeout in milliseconds (ms)
			return wr;
		}
	}
}


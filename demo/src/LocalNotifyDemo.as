package
{
	import com.msuo.net.localNotify.LocalNotify;
	import com.msuo.net.localNotify.LocalNotifyEvent;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * @author Austin 
	 */	
	[SWF(width="600", height="400", frameRate="20", backgroundColor="#FFFFFF")]
	public class LocalNotifyDemo extends Sprite
	{
		
		//==========================================================================
		//  Variables
		//==========================================================================
		private var serverLabel:TextField;
		
		private var localNotify:LocalNotify;
		
		//==========================================================================
		//  Constructor
		//==========================================================================
		/**
		 * Constructs a new <code>LocalNotifyDemo</code> instance.
		 *
		 */
		public function LocalNotifyDemo()
		{
			//ui
			var date:Date = new Date;
			var clientLabel:TextField = new TextField();
			clientLabel.text = "Local ID:"
			addChild(clientLabel);
			
			var clienInput:TextField = new TextField();
			clienInput.text = date.getTime().toString();
			clienInput.x = 60;
			addChild(clienInput);
			
			serverLabel = new TextField();
			serverLabel.text = "Remote ID:";
			serverLabel.y = 30;
			addChild(serverLabel);
			
			var serverInput:TextField = new TextField();
			serverInput.text = date.getTime().toString();
			serverInput.y = 30;
			serverInput.x = 60;
			addChild(serverInput);
			
			//notify
			localNotify = new LocalNotify();
			localNotify.addEventListener(LocalNotifyEvent.TEXT_INFO, onTextInfoHandler);
			localNotify.addEventListener(LocalNotifyEvent.OBJECT_INFO, onObjectInfoHandler);
			localNotify.addEventListener(LocalNotifyEvent.EVENT_INFO, onEventInfoHandler);
			localNotify.start(clienInput.text);
		}
		
		//==========================================================================
		//  Event Handlers
		//==========================================================================
		
		private function onTextInfoHandler(event:LocalNotifyEvent):void
		{
			
		}
		
		private function onObjectInfoHandler(event:LocalNotifyEvent):void
		{
			
		}
		
		private function onEventInfoHandler(event:LocalNotifyEvent):void
		{
			
		}
	}
}
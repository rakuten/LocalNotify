package
{
	import com.msuo.net.localNotify.LocalNotify;
	import com.msuo.net.localNotify.LocalNotifyEvent;
	
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	
	/**
	 * @author Austin 
	 */	
	[SWF(width="600", height="400", frameRate="20", backgroundColor="#FFFFFF")]
	public class LocalNotifyDemo extends Sprite
	{
		
		//==========================================================================
		//  Variables
		//==========================================================================
		private var remoteInput:TextField
		
		private var localInput:TextField;
		
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
			initDisplay();
			initNotify();
		}
		
		//==========================================================================
		//  Methods
		//==========================================================================
		private function initDisplay():void
		{
			var date:Date = new Date;
			var localLabel:TextField = new TextField();
			localLabel.text = "Local ID:"
			addChild(localLabel);
			
			localInput = new TextField();
			localInput.text = date.getTime().toString();
			localInput.x = 60;
			localInput.height = 20;
			addChild(localInput);
			
			var remoteLabel:TextField = new TextField();
			remoteLabel.text = "Remote ID:";
			remoteLabel.y = 30;
			addChild(remoteLabel);
			
			remoteInput = new TextField();
			remoteInput.type = TextFieldType.INPUT;
			remoteInput.text = "";
			remoteInput.y = 30;
			remoteInput.x = 60;
			remoteInput.border = true;
			remoteInput.height = 20,
				addChild(remoteInput);
			
			var startBtn:Sprite = new Sprite();
			startBtn.buttonMode = true;
			startBtn.graphics.beginFill(0xff0000);
			startBtn.graphics.drawRect(0, 0, 50, 25);
			startBtn.graphics.endFill();
			startBtn.x = 200;
			startBtn.y = 30;
			startBtn.addEventListener(MouseEvent.CLICK, btn_clickHandler);
			addChild(startBtn);
		}
		
		private function initNotify():void
		{
			localNotify = new LocalNotify();
			localNotify.addEventListener(LocalNotifyEvent.TEXT_INFO, onTextInfoHandler);
			localNotify.addEventListener(LocalNotifyEvent.OBJECT_INFO, onObjectInfoHandler);
			localNotify.addEventListener(LocalNotifyEvent.EVENT_INFO, onEventInfoHandler);
			localNotify.start(localInput.text);
		}
		
		//==========================================================================
		//  Event Handlers
		//==========================================================================
		private function btn_clickHandler(event:MouseEvent):void
		{
			localNotify.sendText(remoteInput.text, "testString");
			localNotify.sendObject(remoteInput.text, {label1:"test",obj:[1,2]});
//			localNotify.sendEvent(remoteInput.text, 
			
		}
		
		private function onTextInfoHandler(event:LocalNotifyEvent):void
		{
			trace(event.data)
		}
		
		private function onObjectInfoHandler(event:LocalNotifyEvent):void
		{
			trace(event.data)
		}
		
		private function onEventInfoHandler(event:LocalNotifyEvent):void
		{
			
		}
	}
}
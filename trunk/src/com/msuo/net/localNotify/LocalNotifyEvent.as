package com.msuo.net.localNotify
{
	import flash.events.Event;
	
	/**
	 *
	 * @author austin
	 *
	 */
	public class LocalNotifyEvent extends Event
	{
		//==========================================================================
		//  Class variables
		//==========================================================================
		
		static public const TEXT_INFO:String = "textInfo";
		
		static public const OBJECT_INFO:String = "objectInfo";
		
		static public const EVENT_INFO:String = "eventInfo";
		
		static public const COMMAND_INFO:String = "commandInfo";
		
		//==========================================================================
		//  Constructor
		//==========================================================================
		/**
		 * Constructs a new <code>LocalNotifyEvent</code> instance.
		 *
		 */
		public function LocalNotifyEvent(type:String, 
										 bubbles:Boolean = false, 
										 cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		//==========================================================================
		//  Variables
		//==========================================================================
		
		/**
		 * 主数据(可能为对象也可能为字符串)
		 */
		public var data:*;
		
		
		/**
		 * 事件派发时的可选变量
		 * p.s: type == EVENT_INFO时,此值被传送事件的event.type
		 */
		public var param:String;
		
		/**
		 * 发送者的id
		 */
		public var caller:String;
		
		//==========================================================================
		//  Methods
		//==========================================================================
		
		override public function clone():Event
		{
			var evt:LocalNotifyEvent = new LocalNotifyEvent(type, bubbles, cancelable);
			evt.data = this.data;
			evt.param = this.param;
			evt.caller = this.caller;
			return evt;
		}
	}
}
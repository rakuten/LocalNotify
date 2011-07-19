package com.msuo.net.localNotify
{
	import flash.events.Event;
	
	public class LocalNotifyEvent extends Event
	{
		public function LocalNotifyEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
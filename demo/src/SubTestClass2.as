package
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class SubTestClass2 extends EventDispatcher
	{
		public function SubTestClass2(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}
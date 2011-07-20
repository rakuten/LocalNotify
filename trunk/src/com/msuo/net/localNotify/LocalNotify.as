package com.msuo.net.localNotify
{
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	import flash.net.registerClassAlias;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * 收到对象或类实例时派发
	 */
	[Event(name="objectInfo", type="com.msuo.net.localNotify.LocalNotifyEvent")]
	
	/**
	 * 收到文字对象时派发
	 */
	[Event(name="textInfo", type="com.msuo.net.localNotify.LocalNotifyEvent")]
	
	/**
	 * 收到事件类消息时派发
	 */
	[Event(name="eventInfo", type="com.msuo.net.localNotify.LocalNotifyEvent")]
	
	[Event(name="commandInfo", type="com.msuo.net.localNotify.LocalNotifyEvent")]
	
	/**
	 * LocalConnection的扩展实现，既可以发送文本，也可以发送Object或类的实例
	 * @author austin
	 *
	 */
	public class LocalNotify extends EventDispatcher
	{
		static private const CLASS_NAME_STR:String = "LocalNotify";
		//==========================================================================
		//  Constructor
		//==========================================================================
		/**
		 * Constructs a new <code>LocalNotify</code> instance.
		 *
		 */
		public function LocalNotify()
		{
		}
		
		//==========================================================================
		//  Variables
		//==========================================================================
		/**
		 * 是否显示debug信息
		 */
		public var showDebugInfo:Boolean = false;
		
		private var serverLC:LocalConnection;
		private var serverId:String;
		private var typeLib:Object = {};
		
		
		//==========================================================================
		//  Methods
		//==========================================================================
		
		/**
		 * 建立LC侦听
		 * @param id 客户端唯一标识
		 *
		 */
		public function start(id:String):void
		{
			serverId = id;
			serverLC = new LocalConnection();
			serverLC.client = this;
			serverLC.allowDomain("*");
			serverLC.addEventListener(StatusEvent.STATUS, onStatus);
			try
			{
				serverLC.connect(serverId);
			}
			catch (error:ArgumentError)
			{
				trace(LocalNotify+" 侦听出错:" + error.message);
			}
		}
		
		/**
		 * 断开LC的侦听连接
		 *
		 */
		public function close():void
		{
			if (!serverLC)
			{
				return;
			}
			try
			{
				serverLC.close();
			}
			catch (error:ArgumentError)
			{
				trace(LocalNotify+" 关闭出错:" + error.message);
			}
			serverLC = null;
		}
		
		/**
		 * 发送一段文本
		 * @param id 另一头侦听者的id
		 * @param msg
		 *
		 */
		public function sendText(id:String, msg:String):void
		{
			sendHandler(id, "onGetMsgHandler", msg, serverId, null);
		}
		
		/**
		 * 发送一个对象或类实例
		 * @param id 另一头侦听者的id
		 * @param item
		 * @param param
		 *
		 */
		public function sendObject(id:String, item:Object, param:String = null):void
		{
			parseQualifiedClassName(id, item);
			
			sendHandler(id, "onGetObjHandler", item, serverId, param);
		}
		
		/**
		 * 发送一个事件
		 * @param id 另一头侦听者的id
		 * @param type 等同于event.type的值
		 * @param item 可以附带的event的变量(可以是值对象或是构造时不带变量的类)
		 *
		 * p.s:在另一端收取成功后，需自行将事件重新组装
		 *
		 */
		public function sendEvent(id:String, type:String, item:Object = null):void
		{
			if (item)
			{
				parseQualifiedClassName(id, item);
			}
			sendHandler(id,"onGetEventHandler", type, item, serverId);
		}
		
		public function sendCommand(id:String, command:String, data:* = null):void
		{
			sendHandler(id, "onGetCommandHandler", command, data, serverId);
		}
		
		/**
		 * 在内容中注册类(发送方和接受方都需注册才有用)
		 * @param path
		 *
		 */
		public function preRegisterType(path:String):Class
		{
			var classInst:Class = getDefinitionByName(path) as Class;
			registerClassAlias(path, classInst);
			return classInst;
		}
		
		private function parseQualifiedClassName(id:String, obj:*):void
		{
			var path:String = getQualifiedClassName(obj);
			if (path.indexOf("::") > -1)
			{
				var seperator:int = path.indexOf("::");
				path = path.substr(0, seperator) + "." +path.substr((seperator + 2), path.length);
			}
			
			if (typeLib[id+path] == null)
			{
				typeLib[id+path] = preRegisterType(path);
				serverLC.send(id, "preRegisterType", path);
			}
		}
		
		private function sendHandler(...args):void
		{
			if (args[1] != "preRegisterType")
			{
				if (showDebugInfo)
				{
					trace(LocalNotify+" Send to:"+args[0]+" mode:"+args[1]+" type:"+args[2]+" target:"+args[4]);
				}
				serverLC.send(args[0], args[1], args[2], args[3], args[4]);
			}
			else
			{
				if (showDebugInfo)
				{
					trace(LocalNotify+" Send to:"+args[0]+" mode:"+args[1]+" type:"+args[2]);
				}
				serverLC.send(args[0], args[1], args[2]);
			}
		}
		
		/**
		 * 远端发来的消息将会调用此处
		 * @param msg
		 *
		 */
		public function onGetMsgHandler(msg:String, caller:String, param:String = null):void
		{
			var event:LocalNotifyEvent =
				new LocalNotifyEvent(LocalNotifyEvent.TEXT_INFO);
			event.data = msg;
			event.param = param;
			event.caller = caller;
			this.dispatchEvent(event);
		}
		
		public function onGetObjHandler(obj:*, caller:String, param:String = null):void
		{
			var event:LocalNotifyEvent =
				new LocalNotifyEvent(LocalNotifyEvent.OBJECT_INFO);
			event.data = obj;
			event.param = param;
			event.caller = caller;
			this.dispatchEvent(event);
		}
		
		public function onGetEventHandler(type:String, obj:*, caller:String):void
		{
			var event:LocalNotifyEvent =
				new LocalNotifyEvent(LocalNotifyEvent.EVENT_INFO);
			event.data = obj;
			event.param = type;
			event.caller = caller;
			this.dispatchEvent(event);
		}
		
		public function onGetCommandHandler(type:String, obj:*, caller:String):void
		{
			var event:LocalNotifyEvent =
				new LocalNotifyEvent(LocalNotifyEvent.COMMAND_INFO);
			event.data = obj;
			event.param = type;
			event.caller = caller;
			this.dispatchEvent(event);
		}
		
		
		//==========================================================================
		//  Event Handlers
		//==========================================================================
		private function onStatus(event:StatusEvent):void
		{
			switch (event.level)
			{
				case "status":
//                trace("LocalNotify send() succeeded:"+serverId);
					break;
				case "error":
					trace(LocalNotify+" send failed:"+serverId);
					break;
			}
			
		}
	}
}
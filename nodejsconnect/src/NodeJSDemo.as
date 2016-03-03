package {

	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.XMLSocket;
	import flash.text.TextField;
	import flash.ui.Keyboard;

	public class NodeJSDemo extends Sprite
	{
		private var _xmlSocket:XMLSocket;
		private var _textField:TextField;

		public function NodeJSDemo()
		{
			super();

			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);

			_textField = new TextField ();
			_textField.width = 300;
			_textField.height = 300;
			_textField.multiline = true;
			_textField.htmlText = "";
			addChild(_textField);
		}

		private function _onAddedToStage(aEvent : Event):void
		{
			_xmlSocket = new XMLSocket("127.0.0.1", 9001);

			stage.removeEventListener(Event.ADDED_TO_STAGE, 		_onAddedToStage);

			_xmlSocket.addEventListener(Event.CONNECT, 			_onConnected);
			_xmlSocket.addEventListener(IOErrorEvent.IO_ERROR, 	_onIOError);
		}

		private function _onConnected(aEvent : Event):void
		{
			trace("onConnect() aEvent: " + aEvent);

			_xmlSocket.removeEventListener(Event.CONNECT, 			_onConnected);
			_xmlSocket.removeEventListener(IOErrorEvent.IO_ERROR, 	_onIOError);

			_xmlSocket.addEventListener(DataEvent.DATA, 			_onDataReceived);
			_xmlSocket.addEventListener(Event.CLOSE, 				_onSocketClose);

			stage.addEventListener(KeyboardEvent.KEY_UP, 			_onKeyUp);
		}

		private function _onSocketClose(aEvent : Event):void
		{
			trace("_onSocketClose aEvent : " + aEvent);

			stage.removeEventListener(KeyboardEvent.KEY_UP, _onKeyUp);
			_xmlSocket.removeEventListener(Event.CLOSE, _onSocketClose);
			_xmlSocket.removeEventListener(DataEvent.DATA, _onDataReceived);
		}

		private function _onKeyUp(evt:KeyboardEvent):void
		{
			if (evt.keyCode == Keyboard.ESCAPE)
				_xmlSocket.send("exit");
			else
				_xmlSocket.send(evt.keyCode);
		}

		private function _onDataReceived(aEvent : DataEvent):void
		{
			try {
				_textField.htmlText += ("From Server: " + aEvent.data + "\n");
				_textField.scrollV = _textField.maxScrollV;
			} catch (error : Error) {
				trace("_onDataReceived error:  " + error);
			}
		}

		private function _onIOError(aEvent : IOErrorEvent):void
		{
			trace("_onIOError aEvent: " + aEvent);

			_xmlSocket.removeEventListener(Event.CONNECT, _onConnected);
			_xmlSocket.removeEventListener(IOErrorEvent.IO_ERROR, _onIOError);
			stage.addEventListener(MouseEvent.CLICK, _onAddedToStage);
		}

	}
}
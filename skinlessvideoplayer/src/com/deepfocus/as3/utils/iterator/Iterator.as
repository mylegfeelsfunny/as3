package com.deepfocus.as3.utils.iterator
{
	public class Iterator implements IIterator
	{
		
		private var _index:int = 0;
		private var _collection:Array;
		
		private var _isForward:Boolean = true;	
		private var _currentValue:Boolean = true;	
		
		public function Iterator($collection:Array)
		{
			_collection = $collection;
			_index = 0;
		}
		
		public function get index():int	{ return _index; }
		public function set index($value:int):void { _index = $value; }

		public function hasNext():Boolean { return (_index < _collection.length-1); }
		public function hasBefore():Boolean { return (_index > 0); }
				
		public function next():Object
		{
			var curr:int = _index;
			_index++;
			//if (curr > _collection.length - 1) { curr = 0;}
			return _collection[curr];	
		}
		
		public function before():Object
		{
			var curr:int = _index;
			_index--;
			//if (curr < 0) { curr = _collection.length-1;}
			return _collection[curr];	
		}
		
		public function reset():void
		{
			_index = 0;
		}
		
		public function kill():void
		{
			var l:int =  _collection.length;
			var i:int = 0;
			for ( i = 0; i < l; i++ )
			{
				_collection[i] = null;				
			}	
		}

		
	}
}
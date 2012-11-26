package com.deepfocus.as3.utils.iterator
{
	public interface IIterator
	{
		function reset():void
		function next():Object;
		function hasNext():Boolean;
	}
}
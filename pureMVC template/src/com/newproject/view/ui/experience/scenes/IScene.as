package com.office365.view.ui.experience.scenes
{
	import flash.events.Event;

	public interface IScene
	{
		function createBody():void;
		function prepareBody():void;
		function playSection():void;
		function dispatchFinished():void;
		function destroyBody($e:Event):void;
	}
}
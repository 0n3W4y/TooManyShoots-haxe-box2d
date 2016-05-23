package;

import flash.geom.Point;

import flash.events.TimerEvent;



class Director {
		
	private var _camera:Camera;
	private var _timeMaster:TimeMaster;

	private var _zoomedIn:Bool;
	private var _minimumTimeToZoomOut:Int;

	private var _timer:Int;

	public function new(camera:Camera, timeMaster:TimeMaster)
	{
		_camera = camera;
		_timeMaster = timeMaster;
		_zoomedIn = false;
		_minimumTimeToZoomOut = 0;
	}

	public function zoomIn(zoomInPoint:Point)
	{
		if(! _zoomedIn){
			_zoomedIn = true;
			_camera.zoomTo(zoomInPoint);
			_timeMaster.slowMotion();
			_timer = 33;

		}
		
	}

	public function backToNormal()
	{
		if (_zoomedIn)
		{
			if (_timer <= 0){
				_zoomedIn = false;
				_camera.zoomOut();
				_timeMaster.backToNormal();
			}
			else
				_timer--;			
		}		
	}


}
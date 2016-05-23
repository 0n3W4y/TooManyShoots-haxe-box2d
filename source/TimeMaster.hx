package;

class TimeMaster {
	
	private var _frameRate:Float;

	public function new()
	{
		_frameRate = Main.world_step;
	}

	public function getTimeStep()
	{
		return(1 / _frameRate);
	}

	public function slowMotion()
	{
		_frameRate = Main.world_step * 5;
	}

	public function backToNormal()
	{
		_frameRate = Main.world_step;
	}
}
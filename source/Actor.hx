package;


import flash.display.Sprite;
import box2D.dynamics.B2World;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.B2Fixture;
import box2D.collision.shapes.B2CircleShape;

import flash.events.EventDispatcher;
import flash.display.DisplayObject;
import flash.geom.Point;

class Actor extends EventDispatcher{
	
	private var _body:B2Body;
	private var _costume:Sprite;
	public var world_scale:Float;
	public var world:B2World;
	public var world_sprite:Sprite;
	
	public function new(body:B2Body, costume:Sprite){

		world_scale = Global.world_scale;
		world = Global.world;

		_costume = costume;
		_body = body;

		_body.setUserData(this);

		updateMyLook();
		super();
	}

	public function updateNow(){
		if (_body.getType() != STATIC_BODY){
			updateMyLook();
		}
		childSpecificUpdate();

	}

	public function destroy(){
		cleanUpBeforeRemoving();

		_costume.parent.removeChild(_costume);
		world.destroyBody(_body);
	}

	private function cleanUpBeforeRemoving(){

	}

	public function getSpriteLoc()
	{
		return new Point(_costume.x, _costume.y);
	}

	private function updateMyLook(){
		_costume.x = _body.getPosition().x * world_scale;
		_costume.y = _body.getPosition().y * world_scale;
		_costume.rotation = _body.getAngle() * 180/Math.PI;

	}

	private function childSpecificUpdate(){

	}

}
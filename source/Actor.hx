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


class Actor extends EventDispatcher{
	
	private var _body:B2Body;
	private var _costume:Sprite;
	private var world_scale:Float = Main.world_scale;
	private var world:B2World = Main.world;
	
	public function Actor(costume:Sprite){

		_costume = costume;

		var circle = new B2CircleShape (15 / world_scale);
		var bodyDefinition = new B2BodyDef();
		bodyDefinition.position.set (320/world_scale, 180/world_scale);
		bodyDefinition.type = B2Body.b2_dynamicBody;	
		_body = world.createBody(bodyDefinition);
		var fixtureDefinition = new B2FixtureDef ();
		fixtureDefinition.shape = circle;
		fixtureDefinition.friction = 0.8;
		fixtureDefinition.restitution = 0.3;
		fixtureDefinition.density = 0.3;
			
		_body.createFixture (fixtureDefinition);

		updateMyLook();
	}

	public function updateNow(){
	//	if (_body.getType() != STATIC_BODY){
			updateMyLook();
	//	}
		childSpecificUpdate();

	}

	public function destroy(){

	}

	private function updateMyLook(){
		_costume.x = _body.getPosition().x * world_scale;
		_costume.y = _body.getPosition().y * world_scale;
		//_costume.rotation = _body.getAngle() * 180/Math.PI;
	}

	private function childSpecificUpdate(){

	}

}
package;

import flash.geom.Point;
import box2D.collision.shapes.B2CircleShape;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2World;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2DebugDraw;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.B2Fixture;
import flash.display.Sprite;
import flash.events.EventDispatcher;


class PlayerActor extends Actor{

	private static var PLAYER_DIAMETER:Int = 15;
	public var  mContacting:Bool = false;

	private var _parent:Sprite;

	
	public function new(parent, location:Point, initVel:Point){
		_parent = parent;
		var world = Global.world;
		var world_scale = Global.world_scale;
		var world_sprite = _parent;

		var playerSprite = new Sprite();
		playerSprite.graphics.beginFill(0x07aa15, 1);
		playerSprite.graphics.drawCircle(0, 0, PLAYER_DIAMETER);
		playerSprite.graphics.endFill();
		playerSprite.scaleX = PLAYER_DIAMETER / playerSprite.width;
		playerSprite.scaleY = PLAYER_DIAMETER / playerSprite.height;
		world_sprite.addChild(playerSprite);
		
		var circle = new B2CircleShape (PLAYER_DIAMETER/2/ world_scale);
		var bodyDefinition = new B2BodyDef();
		bodyDefinition.position.set (location.x/world_scale, location.y/world_scale);
		bodyDefinition.type = B2Body.b2_dynamicBody;
		bodyDefinition.bullet = true;
		var body = world.createBody(bodyDefinition);
		var fixtureDefinition = new B2FixtureDef ();
		fixtureDefinition.shape = circle;
		fixtureDefinition.friction = 0.1;
		fixtureDefinition.restitution = 0.45;
		fixtureDefinition.density = 1.5;
			
		body.createFixture (fixtureDefinition);
		
		var linVelocity = new B2Vec2(initVel.x/world_scale, initVel.y/world_scale);
		body.setLinearVelocity(linVelocity);
		
		
		super(body, playerSprite);

	}

	override private function childSpecificUpdate(){
		if (_costume.y > _costume.stage.stageHeight){
			dispatchEvent(new BallEvent(BallEvent.BALL_OFF_SCREEN));
			//remove;
		}

		if (mContacting){
			_costume.graphics.clear();
			_costume.graphics.beginFill(0x00ffaa, 1); //green+blue
			_costume.graphics.drawCircle(0, 0, PLAYER_DIAMETER);
			_costume.graphics.endFill();
		}else{
			_costume.graphics.clear();
			_costume.graphics.beginFill(0xff0000, 1); //red
			_costume.graphics.drawCircle(0, 0, PLAYER_DIAMETER);
			_costume.graphics.endFill();
		}
	}

	public function startContact(){
		mContacting = true;
	}

	public function stopContact(){
		mContacting = false;
	}
	public function hitBonusTarget(){
		dispatchEvent(new BallEvent(BallEvent.BALL_HIT_BONUS));
	}

}
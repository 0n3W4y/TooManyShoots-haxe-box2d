package;

import flash.geom.Point;
import flash.display.DisplayObjectContainer;
import box2D.collision.shapes.B2CircleShape;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2World;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2DebugDraw;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.B2Fixture;
import flash.display.Sprite;

class PlayerActor extends Actor{

	private static var PLAYER_DIAMETR:Int = 15;
	private var world_scale:Float = 30;
	
	public function new(parent:DisplayObjectContainer, world:B2World, location:Point, initVel:Point){
		
		var playerSprite = new Sprite();
		playerSprite.graphics.beginFill(0x07aa15, 1);
		playerSprite.graphics.drawCircle(0, 0, PLAYER_DIAMETR);
		playerSprite.graphics.endFill();
		playerSprite.scaleX = PLAYER_DIAMETR / playerSprite.width;
		playerSprite.scaleY = PLAYER_DIAMETR / playerSprite.height;
		parent.addChild(playerSprite);
		
		var circle = new B2CircleShape (PLAYER_DIAMETR/ world_scale);
		var bodyDefinition = new B2BodyDef();
		bodyDefinition.position.set (100/world_scale, 50/world_scale);
		bodyDefinition.type = B2Body.b2_dynamicBody;	
		var body = world.createBody(bodyDefinition);
		var fixtureDefinition = new B2FixtureDef ();
		fixtureDefinition.shape = circle;
		fixtureDefinition.friction = 0.1;
		fixtureDefinition.restitution = 0.45;
		fixtureDefinition.density = 1.5;
			
		body.createFixture (fixtureDefinition);
		

		//var velocityVector = new B2Vec2(initVel.x / world_scale, initVel.y / world_scale);
		//body.setLinearVelocity(velocityVector);
		
		
		super(body, playerSprite);

	}
}
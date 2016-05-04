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

class PlayerActor extends Actor{

	private static var PLAYER_DIAMETER:Int = 15;

	
	public function new(location:Point, initVel:B2Vec2){
		var world = Global.world;
		var world_scale = Global.world_scale;
		var world_sprite = Global.world_sprite;

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
		var body = world.createBody(bodyDefinition);
		var fixtureDefinition = new B2FixtureDef ();
		fixtureDefinition.shape = circle;
		fixtureDefinition.friction = 0.1;
		fixtureDefinition.restitution = 0.45;
		fixtureDefinition.density = 1.5;
			
		body.createFixture (fixtureDefinition);
		
		body.setLinearVelocity(initVel);
		
		
		super(body, playerSprite);

	}
}
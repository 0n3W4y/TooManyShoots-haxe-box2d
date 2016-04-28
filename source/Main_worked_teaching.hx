package;

import box2D.collision.shapes.B2CircleShape;
import box2D.collision.shapes.B2PolygonShape;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2DebugDraw;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.B2World;
import box2D.collision.B2AABB;
import box2D.dynamics.B2Fixture;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.Lib;
import flash.utils.Timer;
import flash.events.TimerEvent;
import flash.display.Stage;

	class Main extends Sprite
	{	
		private var world:B2World;
		private var world_scale:Float;

		private var ballSprite:Sprite;
		private var ballBody:B2Body;

		public static function main () {
		
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
		
		}

		public function new()
		{
			super();	
			init();
		}

		private function init()
		{
			createWorld();
			add_debuger();
			add_walls();
			add_circle();
			addEventListener(Event.ENTER_FRAME, update);
			
		}

		private function add_debuger()
		{
			var debugDraw = new B2DebugDraw();
			var debugSprite = new Sprite();
			addChild (debugSprite);
		
			debugDraw.setSprite (debugSprite);
			debugDraw.setDrawScale (world_scale);
			debugDraw.setFlags (B2DebugDraw.e_shapeBit);
		
			world.setDebugDraw (debugDraw);

		}

		private function createWorld()
		{
			var gravity = new B2Vec2(0, 9.8);
			world = new B2World(gravity, true);
			world_scale = 30;
		}

		private function update(event:Event)
		{
			world.step(1/30, 10, 10);
			world.clearForces();
			world.drawDebugData();

			ballSprite.x = ballBody.getPosition().x * world_scale;
			ballSprite.y = ballBody.getPosition().y * world_scale;


			
		}

		public function add_circle()
		{	
				
			ballSprite = new Sprite();
			ballSprite.graphics.beginFill(0x07aa15, 1);
			ballSprite.graphics.drawCircle(0, 0, 15);
			ballSprite.graphics.endFill();
			addChild(ballSprite);

			var circle = new B2CircleShape (15 / world_scale);
			var bodyDefinition = new B2BodyDef();
			bodyDefinition.position.set (320/world_scale, 180/world_scale);
			bodyDefinition.type = B2Body.b2_dynamicBody;	
			ballBody = world.createBody(bodyDefinition);
			var fixtureDefinition = new B2FixtureDef ();
			fixtureDefinition.shape = circle;
			fixtureDefinition.friction = 0.8;
			fixtureDefinition.restitution = 0.3;
			fixtureDefinition.density = 0.3;
			
			ballBody.setUserData(ballSprite);
			ballBody.createFixture (fixtureDefinition);

		}

		public function add_walls()
		{
			
			var wallLeftSprite = new Sprite();
			wallLeftSprite.graphics.beginFill(0x000015, 0.5);
			wallLeftSprite.graphics.drawRect(0, 0, 20, 360);
			wallLeftSprite.graphics.endFill();
			addChild(wallLeftSprite);
			
			var wallRightSprite = new Sprite();
			wallRightSprite.graphics.beginFill(0x000015, 0.5);
			wallRightSprite.graphics.drawRect(0, 0, 20, 360);
			wallRightSprite.graphics.endFill();
			addChild(wallRightSprite);
			
			var wallTopSprite = new Sprite();
			wallTopSprite.graphics.beginFill(0x000015, 0.5);
			wallTopSprite.graphics.drawRect(0, 0, 640, 20);
			wallTopSprite.graphics.endFill();
			addChild(wallTopSprite);
			
			var wallBotSprite = new Sprite();
			wallBotSprite.graphics.beginFill(0x000015, 0.5);
			wallBotSprite.graphics.drawRect(0, 0, 640, 20);
			wallBotSprite.graphics.endFill();
			addChild(wallBotSprite);
			
			var polygon = new B2PolygonShape ();
			var bodyDefinition = new B2BodyDef();
			var fixtureDefinition = new B2FixtureDef ();
			var wallBody:B2Body;

			bodyDefinition.position.set (320/world_scale, 350/world_scale);
			polygon.setAsBox (640/2/world_scale, 20/2/world_scale);
			wallBody = world.createBody (bodyDefinition);
			fixtureDefinition.shape = polygon;
			wallBody.createFixture(fixtureDefinition);
			
			wallBotSprite.x = (wallBody.getPosition().x - 640/2/world_scale) * world_scale;
			wallBotSprite.y = (wallBody.getPosition().y - 20/2/world_scale) * world_scale;

			bodyDefinition.position.set (320/world_scale, 10/world_scale);
			wallBody = world.createBody (bodyDefinition);
			fixtureDefinition.shape = polygon;
			wallBody.createFixture(fixtureDefinition);

			wallTopSprite.x = (wallBody.getPosition().x - 320/world_scale) * world_scale;
			wallTopSprite.y = (wallBody.getPosition().y - 10/world_scale) * world_scale;

			bodyDefinition.position.set (10/world_scale, 180/world_scale);
			polygon.setAsBox (20/2/world_scale, 360/2/world_scale);
			wallBody = world.createBody (bodyDefinition);
			fixtureDefinition.shape = polygon;
			wallBody.createFixture(fixtureDefinition);

			wallLeftSprite.x = (wallBody.getPosition().x - 10/world_scale) * world_scale;
			wallLeftSprite.y = (wallBody.getPosition().y - 180/world_scale) * world_scale;

			bodyDefinition.position.set (630/world_scale, 180/world_scale);
			wallBody = world.createBody (bodyDefinition);
			fixtureDefinition.shape = polygon;
			wallBody.createFixture(fixtureDefinition);

			wallRightSprite.x = (wallBody.getPosition().x - 10/world_scale) * world_scale;
			wallRightSprite.y = (wallBody.getPosition().y - 180/world_scale) * world_scale;

		}
	}
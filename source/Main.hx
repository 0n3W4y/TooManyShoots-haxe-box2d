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
import flash.geom.Point;

	class Main extends Sprite
	{	
		public static var world:B2World;
		public static var world_scale:Float;

		public var actor:PlayerActor;

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
		//	add_debuger();
			add_walls();
			createActor();
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
			actor.updateNow();			
		}

		public function createActor()
		{	
			actor = new PlayerActor(this, new Point(10, 10), new Point(10, -5));
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
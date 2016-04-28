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
		private var world_scale:Float;
		private	var world:B2World;
		private var world_step:Float = 1/30;
		private var velocityIterations:Int = 10;
		private var positionIterations:Int = 10;
		private var _allActors:Array<Dynamic> = new Array();

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
			createLevel();
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
			Global.world = new B2World(gravity, true);
			Global.world_scale = 30;
			Global.world_sprite = this;

			world = Global.world;
			world_scale = Global.world_scale;
		}

		public function createLevel(){

			var horizSpacing:Int = 36;
			var vetrSpacing:Int = 36;
			var pegBounds:B2PolygonShape = new B2PolygonShape();
			add_walls();
			createActor();
			addSomePegs();
		}

		private function update(event:Event)
		{

			world.step(world_step, velocityIterations, positionIterations);
			world.clearForces();
			world.drawDebugData();
			for (i in 0..._allActors.length){
				_allActors[i].updateNow();
			}
			
		}

		public function createActor(){

			var actor:PlayerActor = new PlayerActor(new Point(200, 20), new Point(8, -1));
			_allActors.push(actor);
			trace ('stage.widt = ' + stage.stageWidth);
		}

		public function addSomePegs(){
			
			var peg1:PegActor = new PegActor(new Point(200, 100), PegActor.NORMAL);
			_allActors.push(peg1);
			var peg2:PegActor = new PegActor(new Point(250, 100), PegActor.GOAL);
			_allActors.push(peg2);
			var peg3:PegActor = new PegActor(new Point(150, 100), PegActor.NORMAL);
			_allActors.push(peg3);
		}

		public function add_walls()
		{	
			
			var wallLeftSprite = new Sprite();
			wallLeftSprite.graphics.beginFill(0x000015, 0.5);
			wallLeftSprite.graphics.drawRect(0, 0, 10, 768);
			wallLeftSprite.graphics.endFill();
			addChild(wallLeftSprite);
			
			var wallRightSprite = new Sprite();
			wallRightSprite.graphics.beginFill(0x000015, 0.5);
			wallRightSprite.graphics.drawRect(0, 0, 10, 768);
			wallRightSprite.graphics.endFill();
			addChild(wallRightSprite);
			
			var wallTopSprite = new Sprite();
			wallTopSprite.graphics.beginFill(0x000015, 0.5);
			wallTopSprite.graphics.drawRect(0, 0, 1366, 10);
			wallTopSprite.graphics.endFill();
			addChild(wallTopSprite);
			
			var wallBotSprite = new Sprite();
			wallBotSprite.graphics.beginFill(0x000015, 0.5);
			wallBotSprite.graphics.drawRect(0, 0, 1366, 10);
			wallBotSprite.graphics.endFill();
			addChild(wallBotSprite);
			
			var polygon = new B2PolygonShape ();
			var bodyDefinition = new B2BodyDef();
			var fixtureDefinition = new B2FixtureDef ();
			var wallBody:B2Body;

			bodyDefinition.position.set (1366/2/world_scale, (768-10/2)/world_scale);
			polygon.setAsBox (1366/2/world_scale, 10/2/world_scale);
			wallBody = world.createBody (bodyDefinition);
			fixtureDefinition.shape = polygon;
			wallBody.createFixture(fixtureDefinition);
			
			wallBotSprite.x = (wallBody.getPosition().x - 1366/2/world_scale) * world_scale;
			wallBotSprite.y = (wallBody.getPosition().y - 10/2/world_scale) * world_scale;

			bodyDefinition.position.set (1366/2/world_scale, 10/2/world_scale);
			wallBody = world.createBody (bodyDefinition);
			fixtureDefinition.shape = polygon;
			wallBody.createFixture(fixtureDefinition);

			wallTopSprite.x = (wallBody.getPosition().x - 1366/2/world_scale) * world_scale;
			wallTopSprite.y = (wallBody.getPosition().y - 10/2/world_scale) * world_scale;

			bodyDefinition.position.set (10/2/world_scale, 768/2/world_scale);
			polygon.setAsBox (10/2/world_scale, 768/2/world_scale);
			wallBody = world.createBody (bodyDefinition);
			fixtureDefinition.shape = polygon;
			wallBody.createFixture(fixtureDefinition);

			wallLeftSprite.x = (wallBody.getPosition().x - 10/2/world_scale) * world_scale;
			wallLeftSprite.y = (wallBody.getPosition().y - 768/2/world_scale) * world_scale;

			bodyDefinition.position.set ((1366-10/2)/world_scale, 768/2/world_scale);
			wallBody = world.createBody (bodyDefinition);
			fixtureDefinition.shape = polygon;
			wallBody.createFixture(fixtureDefinition);

			wallRightSprite.x = (wallBody.getPosition().x - 10/2/world_scale) * world_scale;
			wallRightSprite.y = (wallBody.getPosition().y - 768/2/world_scale) * world_scale;

		}
	}
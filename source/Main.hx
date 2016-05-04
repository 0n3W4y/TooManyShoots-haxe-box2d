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
			add_walls();
			createActor();
			createPegs();
		}

		public function createPegs(){
			var horizSpacing:Int = 36;
			var vetrSpacing:Int = 36;
			var pegBoundsX:Int = 100;
			var pegBoundsY:Int = 250;
			var pegBoundsWidth:Int = 450;
			var pegBoundsHeight:Int = 250;
			var pegY = pegBoundsY;
			var flipWor:Bool = false;
			while(pegY < (pegBoundsY+pegBoundsHeight)){
				pegY += vetrSpacing;
				var pegX = (flipWor) ? pegBoundsX : pegBoundsX + horizSpacing/2;
				flipWor = !flipWor;
				while(pegX < (pegBoundsX+pegBoundsWidth)){
					var newPeg:PegActor = new PegActor(new Point(pegX, pegY), PegActor.NORMAL);
					_allActors.push(newPeg);
					pegX +=horizSpacing;
				}
			}
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

			var actor:PlayerActor = new PlayerActor(new Point(200, 20), new Point(0, 1000));
			_allActors.push(actor);
		}


		public function add_walls()
		{	
			
			//var leftWall:ArbiStaticActor = new ArbiStaticActor();

			//var topWall:ArbiStaticActor = new ArbiStaticActor();

			var lrSize = [10, 768];
			var tbSize = [1366, 10];

			var leftPoint = [100, 100];
			var rightPoint = [1366, 758];
			var topPoint = [1368, 10];
			var botPoint = [1358, 768];

			var leftWall:ArbiStaticActor = new ArbiStaticActor(lrSize, leftPoint);
			/*
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
			*/

		}
	}

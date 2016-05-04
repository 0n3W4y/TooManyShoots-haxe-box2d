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
			var pegBoundsX:Int = 120;
			var pegBoundsY:Int = 100;
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

			var actor:PlayerActor = new PlayerActor(new Point(200, 20), new B2Vec2(0, 0));
			_allActors.push(actor);
		}


		public function add_walls()
		{	
			var lrCoord = new Array();
			lrCoord.push(new B2Vec2(-10/2/world_scale,  -480/2/world_scale));
  			lrCoord.push(new B2Vec2(10/2/world_scale,  -480/2/world_scale));
  			lrCoord.push(new B2Vec2(10/2/world_scale, 480/2/world_scale));
  			lrCoord.push(new B2Vec2(-10/2/world_scale,  480/2/world_scale));

			var tbSize = [720, 10];

			var leftPoint = new B2Vec2(5/world_scale, 480/2/world_scale);
			var rightPoint = new B2Vec2(715/world_scale, 480/2/world_scale);
			//var topPoint = [720, 10];
			//var botPoint = [720, 475*2];

			var leftWall:ArbiStaticActor = new ArbiStaticActor(lrCoord, leftPoint);
			var rightWall:ArbiStaticActor = new ArbiStaticActor(lrCoord, rightPoint);
			//var topWall:ArbiStaticActor = new ArbiStaticActor(tbSize, topPoint);
			//var botWall:ArbiStaticActor = new ArbiStaticActor(tbSize, botPoint);
			
			//set each vertex of polygon in an array
  			var vertices = new Array();
  			vertices.push(new B2Vec2(-10/world_scale,  20/world_scale));
  			vertices.push(new B2Vec2(-10/world_scale,  0));
  			vertices.push(new B2Vec2( 0, -30/world_scale));
  			vertices.push(new B2Vec2(10/world_scale,  0));
  			vertices.push(new B2Vec2( 10/world_scale,  10/world_scale));
  
  			var polygonShape = new B2PolygonShape();
  			polygonShape.setAsArray(vertices, 5); //pass array to the shape
  			var myFixtureDef = new B2FixtureDef();
  			myFixtureDef.shape = polygonShape; //change the shape of the fixture
  			var myBodyDef = new B2BodyDef();
  			myBodyDef.position.set(10, 1); //in the middle
  			myBodyDef.type = B2Body.b2_dynamicBody;
  			var body = world.createBody (myBodyDef);
  			body.createFixture(myFixtureDef);
		}
	}

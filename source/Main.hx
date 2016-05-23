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
import flash.events.MouseEvent;


	class Main extends Sprite
	{	
		private var world_scale:Float;
		private	var world:B2World;
		private var velocityIterations:Int = 10;
		private var positionIterations:Int = 10;
		private var _allActors:Array<Dynamic> = new Array();
		private var _actorsToRemove:Array<Dynamic> = new Array();
		private var _pegsLitUp:Array<Dynamic> = new Array();
		private var _camera:Camera;
		private var _goalPegs:Array<Dynamic> = new Array();
		private var _currentBall:PlayerActor;
		private var LAUNCH_POINT:Point = new Point(720/2, 10);
		private var LAUNCH_VELOCITY:Float = 140.0;
		private var _director:Director;

		private var _timeMaster:TimeMaster;

		public static var world_step:Float = 30;

		public static function main () {
		
		//Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		//Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
		
		}

		public function new()
		{
			super();	
			init();
		}

		private function init()
		{
			_timeMaster = new TimeMaster();
			createWorld();
			addCamera();
			addDirector();

			add_debuger();
			createLevel();
			addEventListener(Event.ENTER_FRAME, update);
			Lib.current.stage.addEventListener(MouseEvent.CLICK, lauchBall);			
		}

		private function addCamera(){
			_camera = new Camera();
			addChild(_camera);
		}

		private function addDirector()
		{
			_director = new Director(_camera, _timeMaster);
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

			world.setContactListener(new ContactListener());
		}

		public function createLevel(){
			add_walls();
			_currentBall = null;
			createPegs();
		}

		public function createPegs(){
			var horizSpacing:Int = 36;
			var vetrSpacing:Int = 36;
			var pegBoundsX:Int = 120;
			var pegBoundsY:Int = 400;
			var pegBoundsWidth:Int = 500;
			var pegBoundsHeight:Int = 250;
			var pegY = pegBoundsY;
			var flipWor:Bool = false;
			while(pegY < (pegBoundsY+pegBoundsHeight)){
				pegY += vetrSpacing;
				var pegX = (flipWor) ? pegBoundsX : pegBoundsX + horizSpacing/2;
				flipWor = !flipWor;
				while(pegX < (pegBoundsX+pegBoundsWidth)){
					var newPeg:PegActor = new PegActor(_camera, new Point(pegX, pegY), PegActor.NORMAL);
					newPeg.addEventListener(PegEvent.PEG_LIT_UP, handlePegLitUp);
					_allActors.push(newPeg);
					pegX +=horizSpacing;
				}
			}
		}

		private function update(event:Event)
		{

			world.step(_timeMaster.getTimeStep(), velocityIterations, positionIterations);
			world.clearForces();
		//	world.drawDebugData();
			for (i in 0..._allActors.length){
				_allActors[i].updateNow();
			}

			checkForZooming();
			removeActor();
			
		}

		private function checkForZooming()
		{
			if(_goalPegs.length == 1 && _currentBall !=null)
			{
				var finalPeg:PegActor = _goalPegs[0];
				var p1:Point = finalPeg.getSpriteLoc();
				var p2:Point = _currentBall.getSpriteLoc();
				if(getDistSquared(p1, p2) < 60*60)
				{
					_director.zoomIn(p1);

				}
				else
				{
					_director.backToNormal();
				}
			}
			else if (_goalPegs.length == 0)
			{
				_director.backToNormal();
			}
		}

		private function getDistSquared(p1:Point, p2:Point)
		{
			return((p2.x - p1.x) * (p2.x - p1.x)) + ((p2.y-p1.y)*(p2.y-p1.y));
		}


		private function handlePlayerOffScreen(event:BallEvent){
			var actorToRemove:PlayerActor = event.currentTarget;
			markToRemoveActor(actorToRemove);
			actorToRemove.removeEventListener(BallEvent.BALL_OFF_SCREEN, handlePlayerOffScreen);
			actorToRemove.removeEventListener(BallEvent.BALL_HIT_BONUS, handlePlayerInBonusChute);

			for (i in 0..._pegsLitUp.length){
				markToRemoveActor(_pegsLitUp[i]);
			}
			_currentBall = null;

			_pegsLitUp = new Array();
		}

		private function handlePegLitUp(event:PegEvent){
			var pegActor:PegActor = event.currentTarget;
			pegActor.removeEventListener(PegEvent.PEG_LIT_UP, handlePegLitUp);
			if (_pegsLitUp.indexOf(pegActor) < 0){
				_pegsLitUp.push(pegActor);
			}
			var goalPegIndex:Int = _goalPegs.indexOf(pegActor);
			if (goalPegIndex > -1)
			{
				_goalPegs.splice(goalPegIndex, 1);
			}
		}

		public function markToRemoveActor(actor:Actor){
			if( _actorsToRemove.indexOf(actor) < 0 ){
				_actorsToRemove.push(actor);

			}
		}

		public function removeActor(){
			for (i in 0..._actorsToRemove.length){
				_actorsToRemove[i].destroy();
				var index = _allActors.indexOf(_actorsToRemove[i]);
				if (index > -1){
					_allActors.splice(index, 1);
				}
			}
			_actorsToRemove = new Array();

		}

		private function lauchBall(event:MouseEvent){

			if(_currentBall == null)
			{
				var direction:Point = new Point(mouseX, mouseY).subtract(LAUNCH_POINT);
				direction.normalize(LAUNCH_VELOCITY);

				var newPlayer:PlayerActor = new PlayerActor(_camera, LAUNCH_POINT, direction);
				newPlayer.addEventListener(BallEvent.BALL_OFF_SCREEN, handlePlayerOffScreen);
				newPlayer.addEventListener(BallEvent.BALL_HIT_BONUS, handlePlayerInBonusChute);
				_allActors.push(newPlayer);
				_currentBall = newPlayer;
			}
			
		}

		private function handlePlayerInBonusChute(event:BallEvent){
			handlePlayerOffScreen(event);
		}


		public function add_walls()
		{	
			var lrCoord = new Array();
			lrCoord.push(new B2Vec2(-10/2/world_scale,  -1280/2/world_scale));
  			lrCoord.push(new B2Vec2(10/2/world_scale,  -1280/2/world_scale));
  			lrCoord.push(new B2Vec2(10/2/world_scale, 1280/2/world_scale));
  			lrCoord.push(new B2Vec2(-10/2/world_scale,  1280/2/world_scale));
/*
			var tbSize = new Array();
			tbSize.push(new B2Vec2(-720/2/world_scale, -10/2/world_scale));
			tbSize.push(new B2Vec2(720/2/world_scale, -10/2/world_scale));
			tbSize.push(new B2Vec2(720/2/world_scale, 10/2/world_scale));
			tbSize.push(new B2Vec2(-720/2/world_scale, 10/2/world_scale));
*/
			var leftPoint = new B2Vec2(5/world_scale, 1280/2/world_scale);
			var rightPoint = new B2Vec2(715/world_scale, 1280/2/world_scale);
			//var topPoint = new B2Vec2(720/2/world_scale, 5/world_scale);
			//var botPoint = new B2Vec2(720/2/world_scale, 475/world_scale);

			var leftWall:ArbiStaticActor = new ArbiStaticActor(_camera, lrCoord, leftPoint);
			var rightWall:ArbiStaticActor = new ArbiStaticActor(_camera, lrCoord, rightPoint);
			//var topWall:ArbiStaticActor = new ArbiStaticActor(tbSize, topPoint);
			//var botWall:ArbiStaticActor = new ArbiStaticActor(tbSize, botPoint);
			
			_allActors.push(leftWall);
			_allActors.push(rightWall);
			//_allActors.push(botWall);
			//_allActors.push(topWall);

			var lRamp = new Array();
			lRamp.push(new B2Vec2(-70/2/world_scale, -30/2/world_scale));
			lRamp.push(new B2Vec2(70/2/world_scale, 20/2/world_scale));
			lRamp.push(new B2Vec2(70/2/world_scale, 30/2/world_scale));
			lRamp.push(new B2Vec2(-70/2/world_scale, -20/2/world_scale));

			var rRamp = new Array();
			rRamp.push(new B2Vec2(-70/2/world_scale, 20/2/world_scale));
			rRamp.push(new B2Vec2(70/2/world_scale, -30/2/world_scale));
			rRamp.push(new B2Vec2(70/2/world_scale, -20/2/world_scale));
			rRamp.push(new B2Vec2(-70/2/world_scale, 30/2/world_scale));

			var lRampPoint1 = new B2Vec2(80/2/world_scale, 600/2/world_scale);
			var lRampPoint2 = new B2Vec2(80/2/world_scale, 800/2/world_scale);
			var lRampPoint3 = new B2Vec2(80/2/world_scale, 1000/2/world_scale);

			var rRampPoint1 = new B2Vec2(680/world_scale, 600/2/world_scale);
			var rRampPoint2 = new B2Vec2(680/world_scale, 800/2/world_scale);
			var rRampPoint3 = new B2Vec2(680/world_scale, 1000/2/world_scale);

			var lRamp1:ArbiStaticActor = new ArbiStaticActor(_camera, lRamp, lRampPoint1);
			var lRamp2:ArbiStaticActor = new ArbiStaticActor(_camera, lRamp, lRampPoint2);
			var lRamp3:ArbiStaticActor = new ArbiStaticActor(_camera, lRamp, lRampPoint3);
			var rRamp1:ArbiStaticActor = new ArbiStaticActor(_camera, rRamp, rRampPoint1);
			var rRamp2:ArbiStaticActor = new ArbiStaticActor(_camera, rRamp, rRampPoint2);
			var rRamp3:ArbiStaticActor = new ArbiStaticActor(_camera, rRamp, rRampPoint3);

			_allActors.push(lRamp1);
			_allActors.push(lRamp2);
			_allActors.push(lRamp3);
			_allActors.push(rRamp1);
			_allActors.push(rRamp2);
			_allActors.push(rRamp3);


			var bonusChute = new BonusChuteActor(_camera, 200, 600, 900);

			_allActors.push(bonusChute);

		}
	}

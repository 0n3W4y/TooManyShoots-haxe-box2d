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

class PegActor extends Actor {

	public static var NORMAL:Int = 1;
	public static var GOAL:Int = 2;

	private static var PEG_DIAMETER:Int = 19;
	private var counter:Int = 0;

	public  var _beenHit:Bool;
	public  var _pegType:Int;
	public  var pegSprite:Sprite;


	public function new(location:flash.geom.Point, type:Int){
		_beenHit = false;
		_pegType = type;
		var world = Global.world;
		var world_scale = Global.world_scale;
		var world_sprite = Global.world_sprite;


		pegSprite = new Sprite();
		pegSprite.graphics.beginFill(0x000000, 1); 
		pegSprite.graphics.drawCircle(0, 0, PEG_DIAMETER);
		pegSprite.graphics.endFill();
		pegSprite.scaleX = PEG_DIAMETER / pegSprite.width;
		pegSprite.scaleY = PEG_DIAMETER / pegSprite.height;
		world_sprite.addChild(pegSprite);

		var circle = new B2CircleShape (PEG_DIAMETER/2/ world_scale);
		var bodyDefinition = new B2BodyDef();
		bodyDefinition.position.set (location.x/world_scale, location.y/world_scale);
		var body = world.createBody(bodyDefinition);
		var fixtureDefinition = new B2FixtureDef ();
		fixtureDefinition.shape = circle;
		fixtureDefinition.friction = 0;
		fixtureDefinition.restitution = 0.45;
		fixtureDefinition.density = 0;
			
		body.createFixture (fixtureDefinition);
		setColor();
		super(body, pegSprite);

		
	}

	public  function hitByPlayer(){
		if (! _beenHit){
			_beenHit = true;
			setColor();
			dispatchEvent(new PegEvent(PegEvent.PEG_LIT_UP));
		}
	}


	public function setColor(){
		if (_pegType == 1){
			if(_beenHit){
				pegSprite.graphics.clear();
				pegSprite.graphics.beginFill(0x00aa00, 1); //green
				pegSprite.graphics.drawCircle(0, 0, PEG_DIAMETER);
				pegSprite.graphics.endFill();
			}
			else{
				pegSprite.graphics.clear();
				pegSprite.graphics.beginFill(0x0000aa, 1);  //blue
				pegSprite.graphics.drawCircle(0, 0, PEG_DIAMETER);
				pegSprite.graphics.endFill();
			}
		}
		else if (_pegType == 2){
			if (_beenHit){
				pegSprite.graphics.clear();
				pegSprite.graphics.beginFill(0xaa0000, 1); //red
				pegSprite.graphics.drawCircle(0, 0, PEG_DIAMETER);
				pegSprite.graphics.endFill();

			}
			else{
				pegSprite.graphics.clear();
				pegSprite.graphics.beginFill(0xaa00aa, 1); //yellow
				pegSprite.graphics.drawCircle(0, 0, PEG_DIAMETER);
				pegSprite.graphics.endFill();
			}
		}
		else{
			trace("Error from set_color");
		}
	}
}
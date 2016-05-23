package;

import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.collision.shapes.B2Shape;
import box2D.collision.shapes.B2PolygonShape;
import box2D.dynamics.B2FixtureDef;
import box2D.common.math.B2Vec2;
import box2D.common.math.B2Transform;
import box2D.common.math.B2Mat22;

class BonusChuteActor extends Actor{

	public var BONUS_TARGET:String = "BonusTarget";

	private var _bounds:Array<Int> = new Array();
	private var _yPos:Int;
	private var _direction:Int;
	private var _parent:Sprite;

	public function new(parent, leftBounds:Int, rightBounds:Int, yPos:Int){

		_parent = parent;
		_bounds.push(leftBounds);
		_bounds.push(rightBounds);
		_yPos = yPos;
		_direction = 1;

		var chuteGraphic:Sprite = createSprite();
		var chuteBody:B2Body = createBody(leftBounds, rightBounds, yPos);

		super(chuteBody, chuteGraphic);

	}

	private function createSprite(){

		var world_sprite = _parent;
		var world_scale = Global.world_scale;
		
		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000, 1);
		sprite.graphics.lineStyle(2, 0x0000ff);
		sprite.graphics.moveTo((-(60+150)/2), (30/2));
		sprite.graphics.lineTo((-(150)/2), (-30/2));
		sprite.graphics.lineTo(((150)/2), (-30/2));
		sprite.graphics.lineTo(((150+60)/2), (30/2));

		sprite.graphics.lineTo((-(60+150)/2), (30/2));
		sprite.graphics.endFill();
		world_sprite.addChild(sprite);

		return sprite;

	}

	override private function childSpecificUpdate()
	{
		var world_scale = 30;
		if (_costume.x >= _bounds[1])
			_direction = -1;
		else if (_costume.x <= _bounds[0])
			_direction = 1;
		var newLocation = new B2Vec2(_costume.x + _direction*2, _yPos);
		var location = new B2Vec2(newLocation.x - _costume.x, _yPos - _costume.y);
		_body.setLinearVelocity(location);



		super.childSpecificUpdate();
	}

	private function createBody(leftBounds, rightBounds, yPos){

		var world = Global.world;
		var world_scale = Global.world_scale;

		var polygonLT = new B2PolygonShape ();
		var polygonRT = new B2PolygonShape ();
		var polygon = new B2PolygonShape ();

		var coordLT = new Array();
		coordLT.push(new B2Vec2((-60-150)/2/world_scale, 30/2/world_scale));
		coordLT.push(new B2Vec2(-150/2/world_scale, -30/2/world_scale));
		coordLT.push(new B2Vec2(-150/2/world_scale, 30/2/world_scale));

		var coordRT = new Array();
		coordRT.push(new B2Vec2(150/2/world_scale, -30/2/world_scale));
		coordRT.push(new B2Vec2((150+60)/2/world_scale, 30/2/world_scale));
		coordRT.push(new B2Vec2(150/2/world_scale, 30/2/world_scale));

		polygonLT.setAsArray(coordLT, coordLT.length);
		polygonRT.setAsArray(coordRT, coordRT.length);
		polygon.setAsBox(150/2/world_scale, 30/2/world_scale);

		var fixtureDefLT = new B2FixtureDef ();
		fixtureDefLT.density = 1;
		fixtureDefLT.friction = 0.1;
		fixtureDefLT.restitution = 0.6;

		var fixtureDefRT = new B2FixtureDef ();
		fixtureDefRT.density = 1;
		fixtureDefRT.friction = 0.1;
		fixtureDefRT.restitution = 0.6;

		var fixtureDef = new B2FixtureDef ();
		fixtureDef.density = 1;
		fixtureDef.friction = 0.1;
		fixtureDef.restitution = 0.6;
		fixtureDef.isSensor = true;
		
		var bodyDef = new B2BodyDef();
		var body:B2Body;

		bodyDef.position.set ((leftBounds+rightBounds)/2/world_scale, yPos/world_scale); 
		bodyDef.type = B2Body.b2_dynamicBody;
		bodyDef.fixedRotation = true;
		body = world.createBody (bodyDef);

		fixtureDefLT.shape = polygonLT;
		fixtureDefRT.shape = polygonRT;
		fixtureDef.shape = polygon;

		body.createFixture(fixtureDefLT);
		body.createFixture(fixtureDef);
		body.createFixture(fixtureDefRT);

		return body;
	}
}
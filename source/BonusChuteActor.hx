package;

import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.collision.shapes.B2Shape;
import box2D.collision.shapes.B2PolygonShape;
import box2D.dynamics.B2FixtureDef;
import box2D.common.math.B2Vec2;

class BonusChuteActor extends Actor{
	
	public function new(leftBounds:Int, rightBounds:Int, yPos:Int){

		var chuteGraphic:Sprite = createSprite();
		var chuteBody:B2Body = createBody(leftBounds, rightBounds, yPos);

		super(chuteBody, chuteGraphic);

	}

	private function createSprite(){

		var world_sprite = Global.world_sprite;
		var world_scale = Global.world_scale;
		
		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000, 1);
		sprite.graphics.lineStyle(2, 0x0000ff);
		sprite.graphics.moveTo((-(60+200+60)/2), (30/2));
		sprite.graphics.lineTo((-(200+60)/2), (-30/2));
		sprite.graphics.lineTo(((200+60)/2), (-30/2));
		sprite.graphics.lineTo(((60+200+60)/2), (30/2));

		sprite.graphics.lineTo((-(60+200+60)/2), (30/2));
		sprite.graphics.endFill();
		world_sprite.addChild(sprite);

		return sprite;

	}

	private function createBody(leftBounds, rightBounds, yPos){

		var world = Global.world;
		var world_scale = Global.world_scale;

		var polygonLT = new B2PolygonShape ();
		var polygonRT = new B2PolygonShape ();
		var polygon = new B2PolygonShape ();

		var coordLT = new Array();
		coordLT.push(new B2Vec2((-60-200)/2/world_scale, 30/2/world_scale));
		coordLT.push(new B2Vec2(-200/2/world_scale, -30/2/world_scale));
		coordLT.push(new B2Vec2(-200/2/world_scale, 30/2/world_scale));

		var coordRT = new Array();
		coordRT.push(new B2Vec2(200/2/world_scale, -30/2/world_scale));
		coordRT.push(new B2Vec2((200+60)/2/world_scale, 30/2/world_scale));
		coordRT.push(new B2Vec2(200/2/world_scale, 30/2/world_scale));

		polygonLT.setAsArray(coordLT, coordLT.length);
		polygonRT.setAsArray(coordRT, coordRT.length);
		polygon.setAsBox(200/2/world_scale, 30/2/world_scale);

		var fixtureDefLT = new B2FixtureDef ();
		fixtureDefLT.density = 0;
		fixtureDefLT.friction = 0.1;
		fixtureDefLT.restitution = 0.6;

		var fixtureDefRT = new B2FixtureDef ();
		fixtureDefRT.density = 0;
		fixtureDefRT.friction = 0.1;
		fixtureDefRT.restitution = 0.6;

		var fixtureDef = new B2FixtureDef ();
		fixtureDef.density = 0;
		fixtureDef.friction = 0.1;
		fixtureDef.restitution = 0.6;
		
		var bodyDef = new B2BodyDef();
		var body:B2Body;

		bodyDef.position.set (400/world_scale, yPos/world_scale); 
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
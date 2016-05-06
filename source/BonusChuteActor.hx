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
		world_sprite.addChild(chuteGraphic);

	}

	private function createSprite(){


		return sprite;
	}

	private function createBody(leftBounds, rightBounds, yPos){

		var polygonLT = new B2PolygonShape ();
		var polygonRT = new B2PolygonShape ();
		var polygon = new B2PolygonShape ();

		var coordLT = new Array();
		coordLT.push(new B2Vec2(-60/2/world_scale, -60/2/world_scale));
		coordLT.push(new B2Vec2(60/2/world_scale, 60/2/world_scale));
		coordLT.push(new B2Vec2(60/2/world_scale, -60/2/world_scale));

		var coordRT = new Array();
		coordRT.push(new B2Vec2(-60/2/world_scale, 60/2/world_scale));
		coordRT.push(new B2Vec2(60/2/world_scale, -60/2/world_scale));
		coordRT.push(new B2Vec2(-60/2/world_scale, -60/2/world_scale));

		polygonLT.setAsArray(coordLT, coordLR.length);
		polygonRT.setAsArray(coordRT, coordRT.length);
		polygon.setAsBox(200/2/world_scale, 60/2/world_scale);

		var fixtureDefLT = new B2FixtureDef ();
		fixtureDefLT.density = 0;
		fixtureDefLT.friction = 0.1;
		fixtureDefLT.restitution = 0.6;

		var fixtureDefRT = new B2FixtureDef ();
		fixtureDefLT.density = 0;
		fixtureDefLT.friction = 0.1;
		fixtureDefLT.restitution = 0.6;

		var fixtureDef = new B2FixtureDef ();
		fixtureDefLT.density = 0;
		fixtureDefLT.friction = 0.1;
		fixtureDefLT.restitution = 0.6;
		
		var bodyDef = new B2BodyDef();
		var body:B2Body;

		bodyDef.position.set ((leftBounds + rightBounds)/2/world_scale, yPos/2/world_scale); 
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
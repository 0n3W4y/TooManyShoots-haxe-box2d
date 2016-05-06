package;

import flash.geom.Point;
import box2D.dynamics.B2World;
import box2D.dynamics.B2Body;
import box2D.collision.shapes.B2PolygonShape;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2FixtureDef;
import box2D.common.math.B2Vec2;
import flash.display.Sprite;


class ArbiStaticActor extends Actor{



	public function new(coord:Array<B2Vec2>, location:B2Vec2){
	    
		var myBody:B2Body = createBody(coord, location);
		var mySprite:Sprite = createSprite(coord, location);
		
		super(myBody, mySprite);
	}

	private function createBody(coord:Array<B2Vec2>, location:B2Vec2){

		var world = Global.world;
		var world_scale = Global.world_scale;
		var world_sprite = Global.world_sprite;
		

		var polygon = new B2PolygonShape ();
		var bodyDef = new B2BodyDef();
		var fixtureDef = new B2FixtureDef ();
		fixtureDef.density = 0.2;
		fixtureDef.friction = 0.3;
		fixtureDef.restitution = 0.4;
		var body:B2Body;

		bodyDef.position.set (location.x, location.y);
		polygon.setAsArray(coord, coord.length);
		body = world.createBody (bodyDef);
		fixtureDef.shape = polygon;
		body.createFixture(fixtureDef);
		



		return body;
	}

	private function createSprite(coord:Array<B2Vec2>, location:B2Vec2){

		var world = Global.world;
		var world_scale = Global.world_scale;
		var world_sprite = Global.world_sprite;
		
		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000, 1);
		sprite.graphics.lineStyle(2, 0x0000ff);
		var firstPoint = coord[0];
		sprite.graphics.moveTo(firstPoint.x*world_scale, firstPoint.y*world_scale);
		for(i in 1...coord.length){
			var nextPoint = coord[i];
			sprite.graphics.lineTo(nextPoint.x*world_scale, nextPoint.y*world_scale);
		}

		sprite.graphics.lineTo(firstPoint.x*world_scale, firstPoint.y*world_scale);
		sprite.graphics.endFill();
		world_sprite.addChild(sprite);

		return sprite;

	}

}
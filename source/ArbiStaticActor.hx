package;

import flash.geom.Point;
import box2D.dynamics.B2World;
import box2D.dynamics.B2Body;
import box2D.collision.shapes.B2PolygonShape;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2FixtureDef;
import flash.display.Sprite;


class ArbiStaticActor extends Actor{

	public function new(size:Array<Dynamic>, location:Array<Dynamic>){
	    
		var myBody:B2Body = createBody(size, location);
		var mySprite:Sprite = createSprite(size, location);
		
		super(myBody, mySprite);
	}

	private function createBody(size:Array<Dynamic>, location:Array<Dynamic>){

		var world = Global.world;
		var world_scale = Global.world_scale;
		var world_sprite = Global.world_sprite;

		var polygon = new B2PolygonShape ();
		var bodyDef = new B2BodyDef();
		var fixtureDef = new B2FixtureDef ();
		fixtureDef.density = 0;
		fixtureDef.friction = 0;
		fixtureDef.restitution = 0;
		var body:B2Body;

		bodyDef.position.set (location[0]/2/world_scale, (location[1]/2)/world_scale);
		polygon.setAsBox (size[0]/2/world_scale, size[1]/2/world_scale);
		body = world.createBody (bodyDef);
		fixtureDef.shape = polygon;
		body.createFixture(fixtureDef);


		return body;
	}

	private function createSprite(size:Array<Dynamic>, location:Array<Dynamic>){

		var world = Global.world;
		var world_scale = Global.world_scale;
		var world_sprite = Global.world_sprite;
		
		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000, 0.5);
		sprite.graphics.drawRect(location[0], location[1], size[0], size[1]);
		sprite.graphics.endFill();
		world_sprite.addChild(sprite);

		return sprite;

	}
}
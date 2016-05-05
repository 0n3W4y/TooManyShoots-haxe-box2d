package;

import box2D.collision.B2ContactPoint;
import box2D.dynamics.contacts.B2Contact;
import box2D.dynamics.B2ContactListener;

class ContactListener extends B2ContactListener{

	public function new(){
		super();
	}

	override public function beginContact(contact:B2Contact){

		var bodyUserData = contact.getFixtureA().getBody().getUserData();

		if (bodyUserData == PlayerActor){
			bodyUserData.startContact();
			trace(" CONTACT! ");
		}

		bodyUserData = contact.getFixtureB().getBody().getUserData();

		if (bodyUserData == PlayerActor){
			bodyUserData.startContact();
			trace(" CONTACT! ");
		}
	}

	override public function endContact(contact:B2Contact){

		var bodyUserData = contact.getFixtureA().getBody().getUserData();

		if (bodyUserData == PlayerActor){
			bodyUserData.stopContact();
			trace("  END contact! ");
		}

		bodyUserData = contact.getFixtureB().getBody().getUserData();

		if (bodyUserData == PlayerActor){
			bodyUserData.stopContact();
			trace("  END contact! ");
		}
	}
	
}
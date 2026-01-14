import firebase_admin
from firebase_admin import credentials, firestore
import datetime

def seed_data():
    """Seed Firestore with Valentine's Day Event Data"""
    try:
        # Initialize Firebase Admin
        # Use a service account key (JSON file) from Firebase Console
        # Make sure this file exists in the same directory or provide full path
        cred = credentials.Certificate('google-services.json')
        firebase_admin.initialize_app(cred)
        db = firestore.client()

        print("--- seeding started ---")

        # 1. Seed Cards (Market Research - Valentine's Edition)
        cards_ref = db.collection('cards')
        
        # Clear existing cards (optional but recommended for event restart)
        # Note: In production, you'd use a batch delete
        for doc in cards_ref.stream():
            doc.reference.delete()

        valentine_cards = [
            {
                "question": "Is a handwritten letter better than a expensive gift?",
                "category": "Romance",
                "imageUrl": "https://images.unsplash.com/photo-1516589174184-c68d196f4544?auto=format&fit=crop&q=80&w=800",
                "createdAt": datetime.datetime.now()
            },
            {
                "question": "First date: Dinner at a restaurant or a long walk in the park?",
                "category": "Dating",
                "imageUrl": "https://images.unsplash.com/photo-1511795409834-ef04bbd61622?auto=format&fit=crop&q=80&w=800",
                "createdAt": datetime.datetime.now()
            },
            {
                "question": "Do you believe in love at first swipe?",
                "category": "Modern Love",
                "imageUrl": "https://images.unsplash.com/photo-1518199266791-5375a83190b7?auto=format&fit=crop&q=80&w=800",
                "createdAt": datetime.datetime.now()
            },
            {
                "question": "Does music play a big role in your romantic life?",
                "category": "Atmosphere",
                "imageUrl": "https://images.unsplash.com/photo-1470225620780-dba8ba36b745?auto=format&fit=crop&q=80&w=800",
                "audioUrl": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
                "createdAt": datetime.datetime.now()
            }
        ]

        for i, card in enumerate(valentine_cards):
            card["orderIndex"] = i
            cards_ref.add(card)
        print(f"Seeded {len(valentine_cards)} cards.")

        # 2. Seed Surveys
        surveys_ref = db.collection('surveys')
        for doc in surveys_ref.stream():
            doc.reference.delete()

        valentine_surveys = [
            {
                "title": "Valentine's Personality Quiz",
                "description": "Tell us about your ideal date and unlock big rewards!",
                "rewardPoints": 500,
                "isActive": True,
                "questions": [
                    {"id": "q1", "text": "What's your ideal gift?", "type": "text"},
                    {"id": "q2", "text": "Are you a romantic? (1-10)", "type": "slider"},
                    {"id": "q3", "text": "Chocolate or Flowers?", "type": "binary"}
                ]
            },
            {
                "title": "Dating App Feedback",
                "description": "How can we make matching more meaningful?",
                "rewardPoints": 300,
                "isActive": True,
                "questions": [
                    {"id": "q1", "text": "Rate our new compatibility engine", "type": "slider"},
                    {"id": "q2", "text": "Would you pay for premium matching?", "type": "binary"}
                ]
            }
        ]

        for survey in valentine_surveys:
            surveys_ref.add(survey)
        print(f"Seeded {len(valentine_surveys)} surveys.")

        # 3. Seed Rewards (Marketplace)
        rewards_ref = db.collection('rewards')
        for doc in rewards_ref.stream():
            doc.reference.delete()

        valentine_rewards = [
            {
                "title": "Dairy Milk Silk (Digital Voucher)",
                "cost": 500,
                "imageUrl": "https://m.media-amazon.com/images/I/61kYmGndI3L._SL1500_.jpg",
                "isDigital": True,
                "stock": 100
            },
            {
                "title": "The Green Ticket (VIP Access)",
                "cost": 1000,
                "imageUrl": "https://img.freepik.com/free-vector/modern-green-ticket-template_1017-14283.jpg",
                "isDigital": True,
                "stock": 10
            },
            {
                "title": "Custom Valentine Playlist",
                "cost": 200,
                "imageUrl": "https://images.unsplash.com/photo-1493225255756-d9584f8606e9?auto=format&fit=crop&q=80&w=800",
                "isDigital": True,
                "stock": 1000
            }
        ]

        for reward in valentine_rewards:
            rewards_ref.add(reward)
        print(f"Seeded {len(valentine_rewards)} rewards.")

        print("--- seeding completed successfully ---")

    except Exception as e:
        print(f"Error seeding data: {e}")

if __name__ == "__main__":
    seed_data()
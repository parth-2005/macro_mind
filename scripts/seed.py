import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

# 1. Initialize Firebase Admin
# Make sure 'service-account.json' is in the same folder
cred = credentials.Certificate('google-services.json')
firebase_admin.initialize_app(cred)

db = firestore.client()

print("🚀 Starting Seed Process...")

# 2. The Data (Converted to Python Syntax)
seed_cards = [
    # --- SECTION 1: THE PILOT (Gujarat Snack Battle) ---
    {
        "id": "pilot_001",
        "type": "binary",
        "question": "Blind Taste Test: Did you prefer Sample A (Spicy) over Sample B?",
        "imageUrl": "https://placehold.co/600x800/FF5722/FFFFFF/png?text=Sample+A+vs+B",
        "orderIndex": 1,
        "category": "pilot_canteen",
        "createdAt": "2026-01-12T23:36:51.000Z",
        "stats": {"yesPercent": 50, "totalVotes": 0},
        "globalAvgHesitation": 800.0,
        "rewardPoints": 10
    },
    {
        "id": "pilot_002",
        "type": "binary",
        "question": "Is ₹20 a fair price for a Samosa in the canteen?",
        "imageUrl": "https://placehold.co/600x800/FFC107/000000/png?text=Samosa+Price",
        "orderIndex": 2,
        "category": "pilot_canteen",
        "createdAt": "2026-01-12T23:36:51.000Z",
        "stats": {"yesPercent": 50, "totalVotes": 0},
        "globalAvgHesitation": 600.0,
        "rewardPoints": 10
    },
    {
        "id": "pilot_003",
        "type": "binary",
        "question": "Should we bring back 'Maggi' to the late-night menu?",
        "imageUrl": "https://placehold.co/600x800/FDD835/000000/png?text=Maggi+Comeback",
        "orderIndex": 3,
        "category": "pilot_canteen",
        "createdAt": "2026-01-12T23:36:51.000Z",
        "stats": {"yesPercent": 50, "totalVotes": 0},
        "globalAvgHesitation": 500.0,
        "rewardPoints": 10
    },
    {
        "id": "pilot_004",
        "type": "binary",
        "question": "Balaji Wafers vs. Lays: Is Balaji the superior chip?",
        "imageUrl": "https://placehold.co/600x800/4CAF50/FFFFFF/png?text=Balaji+vs+Lays",
        "orderIndex": 4,
        "category": "pilot_canteen",
        "createdAt": "2026-01-12T23:36:51.000Z",
        "stats": {"yesPercent": 50, "totalVotes": 0},
        "globalAvgHesitation": 1200.0,
        "rewardPoints": 10
    },

    # --- SECTION 2: GOLDEN TICKETS (Trust Calibration) ---
    {
        "id": "gold_001",
        "type": "golden_ticket",
        "question": "Is the sky blue on a clear day?",
        "imageUrl": "https://placehold.co/600x800/2196F3/FFFFFF/png?text=Sky+Color",
        "orderIndex": 5,
        "category": "calibration",
        "createdAt": "2026-01-12T23:36:51.000Z",
        "stats": {"yesPercent": 99, "totalVotes": 100},
        "globalAvgHesitation": 400.0,
        "majorityAnswer": "RIGHT",
        "rewardPoints": 50
    },
    {
        "id": "gold_002",
        "type": "golden_ticket",
        "question": "Do humans need water to survive?",
        "imageUrl": "https://placehold.co/600x800/00BCD4/FFFFFF/png?text=Water+Survival",
        "orderIndex": 6,
        "category": "calibration",
        "createdAt": "2026-01-12T23:36:51.000Z",
        "stats": {"yesPercent": 99, "totalVotes": 100},
        "globalAvgHesitation": 400.0,
        "majorityAnswer": "RIGHT",
        "rewardPoints": 50
    },
    {
        "id": "gold_003",
        "type": "golden_ticket",
        "question": "Is 2 + 2 = 5?",
        "imageUrl": "https://placehold.co/600x800/F44336/FFFFFF/png?text=Basic+Math",
        "orderIndex": 7,
        "category": "calibration",
        "createdAt": "2026-01-12T23:36:51.000Z",
        "stats": {"yesPercent": 1, "totalVotes": 100},
        "globalAvgHesitation": 600.0,
        "majorityAnswer": "LEFT",
        "rewardPoints": 50
    },

    # --- SECTION 3: CAMPUS LIFE (Engagement) ---
    {
        "id": "life_001",
        "type": "binary",
        "question": "Have you ever skipped a lecture to sleep?",
        "imageUrl": "https://placehold.co/600x800/9C27B0/FFFFFF/png?text=Sleep+vs+Class",
        "orderIndex": 8,
        "category": "lifestyle",
        "createdAt": "2026-01-12T23:36:51.000Z",
        "stats": {"yesPercent": 50, "totalVotes": 0},
        "globalAvgHesitation": 900.0,
        "rewardPoints": 10
    },
    {
        "id": "life_002",
        "type": "binary",
        "question": "Is Python better than Java for interviews?",
        "imageUrl": "https://placehold.co/600x800/3F51B5/FFFFFF/png?text=Python+vs+Java",
        "orderIndex": 9,
        "category": "tech",
        "createdAt": "2026-01-12T23:36:51.000Z",
        "stats": {"yesPercent": 50, "totalVotes": 0},
        "globalAvgHesitation": 1500.0,
        "rewardPoints": 10
    },
    {
        "id": "life_003",
        "type": "binary",
        "question": "Do you believe AI will replace Junior Developers in 2 years?",
        "imageUrl": "https://placehold.co/600x800/607D8B/FFFFFF/png?text=AI+Future",
        "orderIndex": 10,
        "category": "tech",
        "createdAt": "2026-01-12T23:36:51.000Z",
        "stats": {"yesPercent": 50, "totalVotes": 0},
        "globalAvgHesitation": 2000.0,
        "rewardPoints": 10
    },

    # --- SECTION 4: TRAP CARDS (Bot Detection) ---
    {
        "id": "trap_001",
        "type": "trap",
        "question": "Swipe LEFT if you are a human.",
        "imageUrl": "https://placehold.co/600x800/000000/FFFFFF/png?text=READ+CAREFULLY",
        "orderIndex": 11,
        "category": "security",
        "createdAt": "2026-01-12T23:36:51.000Z",
        "stats": {"yesPercent": 0, "totalVotes": 0},
        "globalAvgHesitation": 2500.0,
        "correctTrapAnswer": False, # Python Syntax
        "rewardPoints": 0
    },
    {
        "id": "trap_002",
        "type": "trap",
        "question": "Tap the screen... wait... actually just Swipe RIGHT.",
        "imageUrl": "https://placehold.co/600x800/795548/FFFFFF/png?text=Attention+Check",
        "orderIndex": 12,
        "category": "security",
        "createdAt": "2026-01-12T23:36:51.000Z",
        "stats": {"yesPercent": 0, "totalVotes": 0},
        "globalAvgHesitation": 2000.0,
        "correctTrapAnswer": True, # Python Syntax
        "rewardPoints": 0
    },

    # --- SECTION 5: SPONSORED (Revenue Model) ---
    {
        "id": "ad_001",
        "type": "sponsored",
        "question": "Would you buy a 'Nothing Phone 3' if it costs ₹30k?",
        "imageUrl": "https://placehold.co/600x800/000000/FFFFFF/png?text=Nothing+Phone",
        "orderIndex": 13,
        "category": "market_research",
        "createdAt": "2026-01-12T23:36:51.000Z",
        "stats": {"yesPercent": 50, "totalVotes": 0},
        "globalAvgHesitation": 1200.0,
        "rewardPoints": 50
    },
    {
        "id": "ad_002",
        "type": "sponsored",
        "question": "Are you interested in a 6-month internship at a Fintech startup?",
        "imageUrl": "https://placehold.co/600x800/009688/FFFFFF/png?text=Hiring+Now",
        "orderIndex": 14,
        "category": "recruitment",
        "createdAt": "2026-01-12T23:36:51.000Z",
        "stats": {"yesPercent": 50, "totalVotes": 0},
        "globalAvgHesitation": 1500.0,
        "rewardPoints": 50
    },
    
    # --- SECTION 6: POLITICS (Viral Growth) ---
    {
        "id": "pol_001",
        "type": "binary",
        "question": "Should Student Council elections be held online this year?",
        "imageUrl": "https://placehold.co/600x800/E91E63/FFFFFF/png?text=Student+Elections",
        "orderIndex": 15,
        "category": "politics",
        "createdAt": "2026-01-12T23:36:51.000Z",
        "stats": {"yesPercent": 50, "totalVotes": 0},
        "globalAvgHesitation": 1000.0,
        "rewardPoints": 20
    },
    
    # --- SECTION 7: ENTERTAINMENT & LIFESTYLE (Engagement) ---
    {
        "id": "ent_001",
        "type": "binary",
        "question": "Netflix or YouTube Premium: Which subscription is more worth it?",
        "imageUrl": "https://placehold.co/600x800/E50914/FFFFFF/png?text=Netflix+vs+YouTube",
        "orderIndex": 16,
        "category": "entertainment",
        "createdAt": "2026-01-12T23:36:51.000Z",
        "stats": {"yesPercent": 50, "totalVotes": 0},
        "globalAvgHesitation": 1100.0,
        "rewardPoints": 10
    },
    {
        "id": "ent_002",
        "type": "binary",
        "question": "Would you pay extra for eco-friendly packaging on products?",
        "imageUrl": "https://placehold.co/600x800/4CAF50/FFFFFF/png?text=Eco+Friendly",
        "orderIndex": 17,
        "category": "sustainability",
        "createdAt": "2026-01-12T23:36:51.000Z",
        "stats": {"yesPercent": 50, "totalVotes": 0},
        "globalAvgHesitation": 1300.0,
        "rewardPoints": 10
    },
    {
        "id": "food_001",
        "type": "binary",
        "question": "Swiggy vs Zomato: Do you prefer Swiggy for food delivery?",
        "imageUrl": "https://placehold.co/600x800/FC8019/FFFFFF/png?text=Swiggy+vs+Zomato",
        "orderIndex": 18,
        "category": "food_delivery",
        "createdAt": "2026-01-12T23:36:51.000Z",
        "stats": {"yesPercent": 50, "totalVotes": 0},
        "globalAvgHesitation": 800.0,
        "rewardPoints": 10
    },
    {
        "id": "tech_001",
        "type": "binary",
        "question": "Do you think Crypto/Web3 is the future or just hype?",
        "imageUrl": "https://placehold.co/600x800/F7931A/FFFFFF/png?text=Crypto+Future",
        "orderIndex": 19,
        "category": "tech",
        "createdAt": "2026-01-12T23:36:51.000Z",
        "stats": {"yesPercent": 50, "totalVotes": 0},
        "globalAvgHesitation": 1800.0,
        "rewardPoints": 15
    },
    {
        "id": "game_001",
        "type": "binary",
        "question": "Mobile Gaming (BGMI/COD) vs PC/Console: Do you prefer mobile?",
        "imageUrl": "https://placehold.co/600x800/00D9FF/000000/png?text=Mobile+Gaming",
        "orderIndex": 20,
        "category": "gaming",
        "createdAt": "2026-01-12T23:36:51.000Z",
        "stats": {"yesPercent": 50, "totalVotes": 0},
        "globalAvgHesitation": 1000.0,
        "rewardPoints": 10
    }
]

# 3. Batch Write to Firestore
batch = db.batch()
collection_ref = db.collection('cards')

count = 0
for card in seed_cards:
    doc_ref = collection_ref.document(card['id'])
    batch.set(doc_ref, card)
    count += 1

batch.commit()
print(f"✅ Success! {count} cards seeded to Firestore.")
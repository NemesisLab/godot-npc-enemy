# Nemesis Lab

## What is the goal?

## What's this repository offering you?

## How does it work?

## What do you need?

Once you place a NPCEnemy character on your scene, all your other characters will need is:

- We assume all elements are visible and masked on 1

- A Hurtbox Area2D where 
	- The name contains "Hurtbox". E.g. Hurtbox, MobHurtbox, HurtboxSmall, ...
	- The  Hurtbox is visible and masked on 2

- A Hitbox Area2D where 
	- The name contains "Hitbox". E.g. Hitbox, MobHitbox, HitboxSmall, ...
	- The Hitbox is visible and masked on 2
	- The Hitbox has a get_damage() method

If your characters comply with this simple rules, you will have in your hands the power of a true plug and play character!

Config.Snowballs = 'weapon'
-- @param 'weapon' = xPlayer.addWeapon('weapon_snowball', 1)
-- @param 'item' = xPlayer.addInventoryItem('weapon_snowball', 1)

Config.RequiredCarrot = true -- set true if will be required to make the snowman, if you don't want it to be required set to nil
Config.SnowballsItem = 'weapon_snowball' -- here insert your item name if using param 'weapon'
Config.SnowballsItemCount = 1

Config.RewardForSnowman = 5000 -- if not set nil

Config.WebhookEvent = "" -- here insert your webhook to log all collects


Config.EnableMoneyRewardsForPresents = true -- If you want players to get rewarded for getting a present set to true
Config.RewardForPresent = {2000, 5000} -- You can use random reward by entering two totals in the table or static reward by entering a normal number
-- EXAMPLE: Randomized money reward - {2000, 5000}
-- EXAMPLE: Static money reward - 2000

Config.EnableItemRewardsFroPresents = true  -- If you want players to get carrot for getting a present set to true
Config.CarrotItem = 'carrot' -- By default, this is set to a 'carrot' so that players have a chance which is in (Config.RewardCarrotPercent) to hit this item and with it the ability to make a snowman (for making a snowman you can also give extra money)
Config.RewardCarrotPercent = 20 -- randomize from 1 to number (20 = 20%) (1 = 1%)
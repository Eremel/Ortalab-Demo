SMODS.Joker({
	key = "mystery_soda",
	atlas = "jokers",
	pos = {x = 1, y = 6},
	rarity = 2,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = true,
	config = {extra = {amount = 2}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'salad'} end
        return {vars = {card.ability.extra.amount}}
    end,
    calculate = function(self, card, context) --Mystery Soda Logic
        if context.selling_self then
            local available_tags = get_current_pool('Tag')
            local selected_tags = {}
            for i = 1, card.ability.extra.amount do
                selected_tags[i] = pseudorandom_element(available_tags, pseudoseed('mystery_soda'))
            end
            G.E_MANAGER:add_event(Event({
                func = (function()
                    for _, tag in pairs(selected_tags) do
                        add_tag(Tag(tag, false, 'Big'))
                    end
                    play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                    return true
                end)
            }))
        end
    end
})
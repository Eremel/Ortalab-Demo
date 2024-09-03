SMODS.Joker({
	key = "chameleon",
	atlas = "jokers",
	pos = {x = 0, y = 0},
	rarity = 3,
	cost = 8,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {copied_joker = nil, copied_joker_pos = 1}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = ''} end
        -- if not G.jokers then return {vars = {localize('ortalab_na')}} end
        if card.ability.extra.copied_joker then
            local vars = card.ability.extra.copied_joker:generate_UIBox_ability_table('ortalab_chameleon')
            if G.P_CENTERS[card.ability.extra.copied_joker.config.center_key].loc_vars then vars = G.P_CENTERS[card.ability.extra.copied_joker.config.center_key]:loc_vars({}, card.ability.extra.copied_joker); if vars then vars = vars.vars end end
            info_queue[#info_queue+1] = {set = 'Joker', key = card.ability.extra.copied_joker.config.center_key, specific_vars = vars or nil}
            return {vars = {localize{type = 'name_text', set = "Joker", key = card.ability.extra.copied_joker.config.center_key, nodes = {}}}}
        else
            return {vars = {localize('ortalab_na')}}
        end
    end,
    calculate = function(self, card, context) --Chameleon Joker Logic
        if context.setting_blind and not card.getting_sliced then
            card.ability.extra.copied_joker = nil
            local potential_jokers = {}
            for i=1, #G.jokers.cards do 
                if G.jokers.cards[i] ~= card and G.jokers.cards[i].config.center.key ~= 'chameleon_joker' and G.jokers.cards[i].config.center.blueprint_compat then
                    potential_jokers[#potential_jokers+1] = G.jokers.cards[i]
                end
            end
            if #potential_jokers > 0 then
                local chosen_joker = pseudorandom_element(potential_jokers, pseudoseed('chameleon'))
                card.ability.extra.copied_joker = chosen_joker
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('ortalab_copied')})
                print(card.ability.extra.copied_joker.config.center.key.." is being copied by Chameleon Joker")
            end	
        end
        if card.ability.extra.copied_joker then
            context.blueprint = (context.blueprint and (context.blueprint + 1)) or 1
            context.blueprint_card = context.blueprint_card or card
            if context.blueprint > #G.jokers.cards + 1 then return end
            local other_joker_ret = card.ability.extra.copied_joker:calculate_joker(context)
            if other_joker_ret then 
                other_joker_ret.card = context.blueprint_card or card
                other_joker_ret.colour = G.C.BLUE
                return other_joker_ret
            end
        end
    end
})
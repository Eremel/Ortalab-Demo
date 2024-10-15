SMODS.Joker({
	key = "scam_email",
	atlas = "jokers",
	pos = {x=5,y=5},
	rarity = 1,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	config = {extra = {dollars = 2, rank = 'Jack'}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
		return {vars = {card.ability.extra.dollars, localize(card.ability.extra.rank, 'ranks')}}
	end,
    set_ability = function(self, card)
        if G.playing_cards then
            local ranks_in_deck = {}
            for _, v in ipairs(G.playing_cards) do
                table.insert(ranks_in_deck, v)
            end
            card.ability.extra.rank = pseudorandom_element(ranks_in_deck, pseudoseed('scam_email')).base.value
        end
    end,
	calculate = function(self, card, context)
        if context.setting_blind then
            local ranks_in_deck = {}
            for _, v in ipairs(G.playing_cards) do
                table.insert(ranks_in_deck, v)
            end
            card.ability.extra.rank = pseudorandom_element(ranks_in_deck, pseudoseed('scam_email')).base.value
            card:juice_up()
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize(card.ability.extra.rank, 'ranks')})
        end
		if context.cardarea == G.play and context.individual and context.other_card.base.value == card.ability.extra.rank then
            return {
                card = card,
                dollars = card.ability.extra.dollars
            }
        end
        
    end
})
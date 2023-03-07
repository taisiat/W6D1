# == Schema Information
#
# Table name: responses
#
#  id               :bigint           not null, primary key
#  answer_choice_id :bigint           not null
#  respondent_id    :bigint           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Response < ApplicationRecord

    belongs_to :answer_choice,
    foreign_key: :answer_choice_id,
    class_name: :AnswerChoice

    belongs_to :respondent,
    foreign_key: :respondent_id,
    class_name: :User

    has_one :question,
    through: :answer_choice,
    source: :question

    has_one :poll,
    through: :question,
    source: :poll

    def sibling_responses
        self.question.responses.where.not("responses.id = (?)", self.id)
    end

    def respondent_already_answered?
        self.sibling_responses.exists?(respondent_id: self.respondent_id)
    end

    def not_duplicate_response
        if respondent_already_answered?
            error.add(:respondent, "don't answer twice")
        end
    end
end

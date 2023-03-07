# == Schema Information
#
# Table name: questions
#
#  id         :bigint           not null, primary key
#  text       :string           not null
#  poll_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Question < ApplicationRecord
    validates :text, presence:true

    has_many :answer_choices,
    foreign_key: :question_id,
    class_name: :AnswerChoice,
    dependent: :destroy

    belongs_to :poll,
    foreign_key: :poll_id,
    class_name: :Poll

    has_many :responses,
    through: :answer_choices,
    source: :responses

    def results
        results = {}
        self.answer_choices.each do |choice|
            results[choice] = choice.responses.count
        end
        results
    end

    def resultsv2
        results = {}
        self.answer_choices.includes(:responses).each do |choice|
            results[choice] = choice.responses.length
        end
        results
    end

    def better
        execute(<<-SQL)
            SELECT
                answer_choices.*, COUNT(answer_choices.id)
            FROM
                answer_choices
            LEFT OUTER JOIN
                responses ON answer_choices.id = responses.answer_choice_id
            WHERE
                answer_choices.question_id = self.id
            GROUP BY
                answer_choices.id;
            

        SQL
    end
end

    acs = self.answer_choices
        .select(*, 'COUNT(answer_choices.id)')
        .left_outer_joins(:responses)
        .group(:id)
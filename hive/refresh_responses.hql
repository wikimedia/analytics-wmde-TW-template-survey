create table awight.template_survey_responses as
select
  dt,
  wiki,
  event.surveyCodeName,
  event.surveyResponseValue
from event.quicksurveysresponses
where
  year = 2020
  and month >= 6
  -- Filter out early, test responses.
  and dt > '2020-06-26T10:02:41Z'
  and event.surveyCodeName like 'wmde-tw-template-survey-prototype-%';

create table awight.template_survey_flat_answers as
select answer
from awight.template_survey_responses
    lateral view explode(split(surveyresponsevalue, ',')) response_table as answer;

create table awight.template_survey_totals as
select
    answer,
    count(*)
from awight.template_survey_flat_answers
group by answer;

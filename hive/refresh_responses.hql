drop table if exists awight.template_survey_responses;
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

drop table if exists awight.template_survey_flat_answers;
create table awight.template_survey_flat_answers as
select
    dt,
    substring(surveycodename, -1) as group_no,
    answer
from awight.template_survey_responses
    lateral view explode(split(surveyresponsevalue, ',')) response_table as answer;

drop table if exists awight.template_survey_totals;
create table awight.template_survey_totals as
select
    group_no,
    answer,
    count(*)
from awight.template_survey_flat_answers
group by answer, group_no;

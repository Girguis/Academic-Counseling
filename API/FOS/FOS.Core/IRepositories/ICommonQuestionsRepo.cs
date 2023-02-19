﻿using FOS.Core.Models;
using FOS.Core.SearchModels;
using FOS.DB.Models;

namespace FOS.Core.IRepositories
{
    public interface ICommonQuestionsRepo
    {
        CommonQuestion GetQuestion(int id);
        List<CommonQuestion> GetQuestions(out int totalCount,SearchCriteria criteria);
        bool AddQuestion(List<QuestionModel> questions);
        bool UpdateQuestion(CommonQuestion question);
        bool DeleteQuestion(CommonQuestion question);
    }
}
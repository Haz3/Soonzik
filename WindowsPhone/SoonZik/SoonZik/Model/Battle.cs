using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.Model
{
    public class Battle
    {
        #region Attribute

        private int _id;
        private DateTime _startTime;
        private DateTime _endTime;
        private Users _usersOne;
        private Users _usersTwo;
        private int _nbVoteA;
        private int _nbVoteB;
        private Users _usersVote;

        #endregion

        #region Ctor

        public Battle()
        {
            
        }
        #endregion
    }
}

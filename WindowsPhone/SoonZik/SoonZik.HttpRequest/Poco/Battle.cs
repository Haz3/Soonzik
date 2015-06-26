using System.Collections.Generic;

namespace SoonZik.HttpRequest.Poco
{
    public class Battle
    {
        #region Attribute
        public int Id { get; set; }
        public string DateBegin { get; set; }
        public object DateEnd { get; set; }
        public int ArtistOneId { get; set; }
        public int ArtistTwoId { get; set; }
        public string CreatedAt { get; set; }
        public string UpdatedAt { get; set; }
        public User ArtistOne { get; set; }
        public User ArtistTwo { get; set; }
        public List<object> Votes { get; set; }
        #endregion
    }
}

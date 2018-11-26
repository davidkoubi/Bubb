using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Bubble.Models
{
    public class Message
    {
        public int Id { get; set; }
        [Required]
        public string Title { get; set; }
        [Required]
        public string MessageText { get; set; }
        [Required]
        public double Longitude { get; set; }
        [Required]
        public double Latitude { get; set; }
  
        public int Views { get; set; }
        public string ImageURL { get; set; }


        [Required]
        public int AuthorId { get; set; }
    }
}
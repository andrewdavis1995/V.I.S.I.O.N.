using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace Pro_saic
{
    /// <summary>
    /// Interaction logic for Classification.xaml
    /// </summary>
    public partial class Classification : Window
    {
        bool[,] settings = new bool[3, 3];

        MLApp.MLApp matlab = new MLApp.MLApp();

        public Classification()
        {
            InitializeComponent();
            settings[0, 1] = true;
            settings[1, 0] = true;
            settings[1, 2] = true;
            settings[2, 1] = true;

            settings[0, 0] = false;
            settings[0, 2] = false;
            settings[2, 2] = false;
            settings[2, 0] = false;
        }

        private void label_Copy_MouseDown(object sender, MouseButtonEventArgs e)
        {
            Label clicked = (Label)sender;

            string[] split = clicked.Tag.ToString().Split(',');

            int y = int.Parse(split[0]);
            int x = int.Parse(split[1]);

            clicked.Background = GetColor(x,y);
        }

        private Brush GetColor(int x, int y)
        {
            settings[y,x] = !settings[y,x];

            if (settings[y, x] == true) { return Brushes.LimeGreen; } else { return Brushes.Red; }

        }

        private void button_Click(object sender, RoutedEventArgs e)
        { 

            object result = null;

            // Call the MATLAB function 
            matlab.Feval("IndividualKNN", 1, out result, settings, "C:\\users\\asuth\\Desktop\\pokemong.jpg");

            MessageBox.Show("DONE");

        }

        private void cmdNatural_Click(object sender, RoutedEventArgs e)
        {
            object result = null;

            matlab.Feval("KNNCalc", 1, out result, settings, "C:\\Users\\asuth\\Desktop\\Vision\\Training\\Natural\\");

            MessageBox.Show("DONE");
        }

        private void cmdManmade_Click(object sender, RoutedEventArgs e)
        {
            object result = null;

            matlab.Feval("KNNCalc", 1, out result, settings, "C:\\Users\\asuth\\Desktop\\Vision\\Training\\Manmade\\");

            MessageBox.Show("DONE");
        }
    }
}

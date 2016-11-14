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
using System.Windows.Navigation;
using System.Windows.Shapes;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Win32;
using System.IO;

namespace Pro_saic
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        string fileSelected = "";
        int gaussian = 0;


        MLApp.MLApp matlab = new MLApp.MLApp();

        public MainWindow()
        {
            InitializeComponent();
        }

        Bitmap GetBitmap(string path)
        {

            object result = null;

            
            // Call the MATLAB function 
            matlab.Feval("ReadImage", 1, out result, path, rows, columns, gaussian);

            // Display result 
            object[] res = result as object[];

            byte[,,] bs = res[0] as byte[,,];

            int w = bs.GetLength(1);
            int h = bs.GetLength(0);

            //var h = bs.Length;
            //var w = bs[0].Length;

            Bitmap bmp = new Bitmap(w, h);

            for (int i = 0; i < bmp.Height; i++)
            {
                for (int j = 0; j < bmp.Width; j++)
                {
                    System.Drawing.Color c = System.Drawing.Color.FromArgb(bs[i, j, 0], bs[i, j, 1], bs[i, j, 2]);

                    bmp.SetPixel(j, i, c);
                }
            }

            return bmp;


        }

        //http://stackoverflow.com/questions/22499407/how-to-display-a-bitmap-in-a-wpf-image
        BitmapImage BitmapToBitmapImage(Bitmap bitmap)
        {
            using (MemoryStream memory = new MemoryStream())
            {
                bitmap.Save(memory, System.Drawing.Imaging.ImageFormat.Bmp);
                memory.Position = 0;
                BitmapImage bitmapimage = new BitmapImage();
                bitmapimage.BeginInit();
                bitmapimage.StreamSource = memory;
                bitmapimage.CacheOption = BitmapCacheOption.OnLoad;
                bitmapimage.EndInit();

                return bitmapimage;
            }
        }
        
        void StartThread()
        {
            if (fileSelected.Length > 0)
            {
                Bitmap bmp = GetBitmap(fileSelected);
                

                imgOutput.Dispatcher.Invoke(new ShowImageDele(() => DisplayOutput(bmp)));
                                
            }
            else
            {
                MessageBox.Show("No File Selected");
            }
        }


        public void DisplayOutput(Bitmap bmp)
        {

            BitmapImage bImage = BitmapToBitmapImage(bmp);

            try
            {
                imgOutput.Source = bImage;
            }
            catch (Exception e)
            {
                MessageBox.Show(e.Message);
            }
        }
        
        public delegate void HideLoadingMaskDele();
        public delegate BitmapImage GetImageDele();
        public delegate void ShowImageDele();

        int rows = 0;
        int columns = 0;
        string file = "";

        void CreateImage()
        {
            Thread thr = new Thread(StartThread);
            thr.Start();

            thr.Join();

            Overlay.Dispatcher.Invoke(new HideLoadingMaskDele(HideLoadingMask));             
          
        }

        void HideLoadingMask()
        {
            Overlay.Visibility = Visibility.Hidden;
        }
        
        private void cmdSelectFile_Click(object sender, RoutedEventArgs e)
        {
            OpenFileDialog fd = new OpenFileDialog();
            fd.Title = "Select Image File";
            fd.Filter = "JPG files|*.jpg";

            var result = fd.ShowDialog();
            if (result == true)
            {
                lblFileSelected.Content = "Selected File: " + fd.FileName;
                fileSelected = fd.FileName;

                BitmapImage image = new BitmapImage();
                image.BeginInit();
                image.UriSource = new Uri(fileSelected);
                image.EndInit();
                imgOutput.Source = image;

            }
            else
            {
                lblFileSelected.Content = "Selected File: None";
                imgOutput.Source = null;
                fileSelected = "";
            }
        }

        private void trackbarRows_ValueChanged(object sender, RoutedPropertyChangedEventArgs<double> e)
        {
            try {
                lblNumRows.Content = trackbarRows.Value.ToString();
            }
            catch (Exception) { }
        }

        private void trackbarColumns_ValueChanged(object sender, RoutedPropertyChangedEventArgs<double> e)
        {
            try
            {
                lblNumColumns.Content = trackbarColumns.Value.ToString();
            }
            catch (Exception) { }
        }

        private void cmdGo_Click(object sender, RoutedEventArgs e)
        {
            rows = (int)trackbarRows.Value;
            columns = (int)trackbarColumns.Value;

            if (checkBoxGaussian.IsChecked == true)
            {
                gaussian = (int)trackbarGaussian.Value;
            }
            else
            {
                gaussian = 0;
            }

            Overlay.Visibility = Visibility.Visible;
            
            Thread thr = new Thread(CreateImage);
            thr.Start();


        }

        private void checkBoxGaussian_Checked(object sender, RoutedEventArgs e)
        {
            trackbarGaussian.IsEnabled = true;
        }

        private void checkBoxGaussian_Unchecked(object sender, RoutedEventArgs e)
        {
            trackbarGaussian.IsEnabled = false;
        }

        private void trackbarGaussian_ValueChanged(object sender, RoutedPropertyChangedEventArgs<double> e)
        {
            try
            {
                lblGaussian.Content = trackbarGaussian.Value;
            }
            catch (Exception) { }
        }

        private void cmdSave_Click(object sender, RoutedEventArgs e)
        {
            BitmapImage bi = (BitmapImage)imgOutput.Source;

            SaveFileDialog sfd = new SaveFileDialog();

            sfd.Filter = "JPG files (*.jpg)|*.jpg";
            
            if(sfd.ShowDialog() == true)
            {
                //https://msdn.microsoft.com/en-us/library/aa970689(v=vs.110).aspx
                FileStream stream = new FileStream(sfd.FileName, FileMode.Create);
                JpegBitmapEncoder encoder = new JpegBitmapEncoder();
                encoder.QualityLevel = 30;
                encoder.Frames.Add(BitmapFrame.Create(bi));
                encoder.Save(stream);
                stream.Close();
            }


        }
    }
}

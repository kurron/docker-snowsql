class Hello {
    public static void main( String[] args ) throws Exception {
        java.util.ArrayList<byte[]> bytes = new java.util.ArrayList<>( 1024 );

        while( true ) {
            System.out.println( "Allocating more heap..." );
            bytes.add( new byte[1024 * 1024] );
            Thread.currentThread().sleep( 2000 );
        }
    }
}

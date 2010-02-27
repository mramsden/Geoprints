package EPrints::Plugin::InputForm::Component::GeoPrints;

use EPrints::Plugin::InputForm::Component;

@ISA = ( 'EPrints::Plugin::InputForm::Component' );

use strict;

sub new
{
	my( $class, %opts ) = @_;

	my $self = $class->SUPER::new( %opts );

	$self->{name} = "GeoPrints";
	$self->{visible} = "all";

	# This is a compatibility step, this can be removed later
	# once the EPrints 3.2 API get's updated.
	$self->{repository} = $self->{session};

	return $self;
}

sub render_content
{
	my( $self ) = @_;

	my $repository = $self->{repository};
	my $eprint = $self->{dataobj};

	my $frag = $repository->xml->create_document_fragment;

	my @documents = $eprint->get_all_documents;

	if( @documents )
	{
		$frag->appendChild( $self->_render_interface );
	}
	else
	{
		my $no_documents = $repository->xml->create_element( 'p' );
		$no_documents->appendChild( $self->html_phrase( 'no_documents' ) );
		$frag->appendChild( $no_documents );
	}

	return $frag;
}

sub render_help
{
	my( $self, $surround ) = @_;

	return $self->html_phrase( 'help' );
}

sub render_title
{
	my( $self, $surround )  = @_;

	return $self->html_phrase( 'title' );
}

sub _render_interface
{
	my( $self ) = @_;

	my $repository = $self->{repository};
	my $eprint = $self->{dataobj};
	
	my $frag = $repository->xml->create_document_fragment;

	my $table = $repository->xml->create_element( 'table' );
	my $thead = $repository->xml->create_element( 'thead' );
	my $tbody = $repository->xml->create_element( 'tbody' );

	my $thead_row = $repository->xml->create_element( 'tr' );
	my $thead_row_cell = $repository->xml->create_element( 'td' );
	$thead_row_cell->appendChild( $self->html_phrase( 'filename' ) );
	$thead_row->appendChild( $thead_row_cell );
	$thead->appendChild( $thead_row );

	my( $tbody_row, $td );

	my @documents = $eprint->get_all_documents;

	foreach my $document ( @documents )
	{
		$tbody_row = $repository->xml->create_element( 'tr' );

		$td = $repository->xml->create_element( 'td' );
		$td->appendChild( $repository->xml->create_text_node( $document->get_main ) );
		$tbody_row->appendChild( $td );

		my $geoprint_url = $repository->get_conf( 'perl_url' ).'/users/geoprints?eprintid='.$eprint->get_id.'&documentid='.$document->get_id;
		my $link = $repository->xml->create_element( 'a', href => $geoprint_url );
		$link->appendChild( $repository->xml->create_text_node( 'geoprint' ) );
		$td = $repository->xml->create_element( 'td' );
		$td->appendChild( $link );
		$tbody_row->appendChild( $td );

		$tbody->appendChild( $tbody_row );
	}

	$table->appendChild( $thead );
	$table->appendChild( $tbody );
	$frag->appendChild( $table );

	return $frag;
}
1;
